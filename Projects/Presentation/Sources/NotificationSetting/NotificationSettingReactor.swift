import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain
import FirebaseMessaging

public final class NotificationSettingReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let subscribeNotificationUseCase: SubscribeNotificationUseCase
    private let subscribeAllNotificationUseCase: SubscribeAllNotificationUseCase
    private let fetchSubscribeStateUseCase: FetchSubscribeStateUseCase

    public init(
        subscribeNotificationUseCase: SubscribeNotificationUseCase,
        subscribeAllNotificationUseCase: SubscribeAllNotificationUseCase,
        fetchSubscribeStateUseCase: FetchSubscribeStateUseCase
    ) {
        self.initialState = .init()
        self.subscribeNotificationUseCase = subscribeNotificationUseCase
        self.subscribeAllNotificationUseCase = subscribeAllNotificationUseCase
        self.fetchSubscribeStateUseCase = fetchSubscribeStateUseCase
    }

    public enum Action {
        case fetchNotificationSettings
        case toggleNotification(NotificationType)
        case toggleAllNotifications
    }

    public enum Mutation {
        case setSubscribeStates([NotificationType: Bool])
        case setLoading(Bool)
        case setFetching(Bool)
    }

    public struct State {
        var subscribeStates: [NotificationType: Bool] = [:]
        var isLoading = false
        var isFetching = false

        var isNoticeEnabled: Bool {
            subscribeStates[.notice] ?? false
        }
        var isApplicationEnabled: Bool {
            subscribeStates[.application] ?? false
        }
        var isRecruitmentEnabled: Bool {
            subscribeStates[.recruitment] ?? false
        }
        var isWinterInternEnabled: Bool {
            subscribeStates[.winterIntern] ?? false
        }
        var isAllNotificationEnabled: Bool {
            Self.isAllEnabled(subscribeStates)
        }

        static func isAllEnabled(_ states: [NotificationType: Bool]) -> Bool {
            NotificationType.allCases.allSatisfy { states[$0] == true }
        }
    }
}

extension NotificationSettingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNotificationSettings:
            return .concat(
                .just(.setLoading(true)),
                .just(.setFetching(true)),
                fetchStates()
                    .asObservable()
                    .map { Mutation.setSubscribeStates($0) }
                    .catch { _ in .empty() },
                .just(.setFetching(false)),
                .just(.setLoading(false))
            )

        case let .toggleNotification(notificationType):
            return refreshAfter(
                subscribeNotificationUseCase.execute(
                    token: Messaging.messaging().fcmToken ?? "",
                    notificationType: notificationType
                )
            )

        case .toggleAllNotifications:
            let shouldEnable = !currentState.isAllNotificationEnabled
            return refreshAfter(
                subscribeAllNotificationUseCase.execute(),
                retryEnableAll: shouldEnable
            )
        }
    }

    private func fetchStates() -> Single<[NotificationType: Bool]> {
        fetchSubscribeStateUseCase.execute()
            .map { entities in
                Dictionary(
                    entities.map { ($0.topic, $0.isSubscribed) },
                    uniquingKeysWith: { _, latest in latest }
                )
            }
    }

    private func refreshAfter(
        _ request: Completable,
        retryEnableAll: Bool = false
    ) -> Observable<Mutation> {
        let refreshed = request
            .catch { _ in .empty() }
            .andThen(fetchStates())
            .flatMap { [weak self] states -> Single<[NotificationType: Bool]> in
                guard let self, retryEnableAll, !State.isAllEnabled(states) else {
                    return .just(states)
                }
                return self.subscribeAllNotificationUseCase.execute()
                    .catch { _ in .empty() }
                    .andThen(self.fetchStates())
            }
            .asObservable()
            .map { Mutation.setSubscribeStates($0) }
            .catch { _ in .empty() }

        return .concat(
            .just(.setLoading(true)),
            refreshed,
            .just(.setLoading(false))
        )
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setSubscribeStates(states):
            newState.subscribeStates = states

        case let .setLoading(isLoading):
            newState.isLoading = isLoading

        case let .setFetching(isFetching):
            newState.isFetching = isFetching
        }

        return newState
    }
}
