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
        case toggleNotificationState(NotificationType)
        case setAllNotificationStates(Bool)
    }

    public struct State {
        var subscribeStates: [NotificationType: Bool] = [:]

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
            isNoticeEnabled && isApplicationEnabled && isRecruitmentEnabled && isWinterInternEnabled
        }
    }
}

extension NotificationSettingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNotificationSettings:
            return fetchSubscribeStateUseCase.execute()
                .asObservable()
                .map { entities -> [NotificationType: Bool] in
                    var states: [NotificationType: Bool] = [:]
                    entities.forEach { states[$0.topic] = $0.isSubscribed }
                    return states
                }
                .map { .setSubscribeStates($0) }

        case let .toggleNotification(notificationType):
            return subscribeNotificationUseCase.execute(
                token: Messaging.messaging().fcmToken ?? "",
                notificationType: notificationType
            )
            .asObservable()
            .map { _ in .toggleNotificationState(notificationType) }

        case .toggleAllNotifications:
            let newState = !currentState.isAllNotificationEnabled
            return subscribeAllNotificationUseCase.execute()
                .asObservable()
                .map { _ in .setAllNotificationStates(newState) }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setSubscribeStates(states):
            newState.subscribeStates = states

        case let .toggleNotificationState(notificationType):
            let currentValue = newState.subscribeStates[notificationType] ?? false
            newState.subscribeStates[notificationType] = !currentValue

        case let .setAllNotificationStates(isEnabled):
            newState.subscribeStates[.notice] = isEnabled
            newState.subscribeStates[.application] = isEnabled
            newState.subscribeStates[.recruitment] = isEnabled
            newState.subscribeStates[.winterIntern] = isEnabled
        }

        return newState
    }
}
