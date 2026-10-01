import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public enum NotificationFilter {
    case all, unread, read
}

public final class AlarmReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchNotificationListUseCase: FetchNotificationListUseCase
    private let readNotificationUseCase: ReadNotificationUseCase

    public init(
        fetchNotificationListUseCase: FetchNotificationListUseCase,
        readNotificationUseCase: ReadNotificationUseCase
    ) {
        self.initialState = .init()
        self.fetchNotificationListUseCase = fetchNotificationListUseCase
        self.readNotificationUseCase = readNotificationUseCase
    }

    public enum Action {
        case fetchNotificationList
        case readNotification(NotificationEntity, Int)
        case filterChanged(NotificationFilter)
    }

    public enum Mutation {
        case setNotificationList([NotificationEntity])
        case updateNotification(index: Int, notification: NotificationEntity)
        case setFilter(NotificationFilter)
    }

    public struct State {
        var notificationList: [NotificationEntity] = []
        var filter: NotificationFilter = .all
        var filteredList: [NotificationEntity] {
            switch filter {
            case .all:    return notificationList
            case .unread: return notificationList.filter { $0.new }
            case .read:   return notificationList.filter { !$0.new }
            }
        }
    }
}

extension AlarmReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNotificationList:
            return fetchNotificationListUseCase.execute()
                .asObservable()
                .flatMap { list -> Observable<Mutation> in
                    .just(.setNotificationList(list))
                }

        case let .readNotification(notification, index):
            let updatedNotification = NotificationEntity(
                notificationID: notification.notificationID,
                title: notification.title,
                content: notification.content,
                topic: notification.topic,
                detailID: notification.detailID,
                createdAt: notification.createdAt,
                new: false
            )
            return readNotificationUseCase.execute(id: notification.notificationID)
                .andThen(.just(.updateNotification(index: index, notification: updatedNotification)))

        case .filterChanged(let filter):
            return .just(.setFilter(filter))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setNotificationList(list):
            newState.notificationList = list

        case let .updateNotification(index, notification):
            if index < newState.notificationList.count {
                newState.notificationList[index] = notification
            }

        case let .setFilter(filter):
            newState.filter = filter
        }
        return newState
    }
}
