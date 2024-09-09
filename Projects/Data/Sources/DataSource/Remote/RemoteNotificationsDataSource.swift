import RxSwift
import RxCocoa
import Domain

public protocol RemoteNotificationsDataSource {
    func fetchNotificationList() -> Single<[NotificationEntity]>
    func patchReadNotification(id: Int) -> Completable
    func subscribeNotification(token: String, notificationType: NotificationType) -> Completable
    func subscribeAllNotification() -> Completable
    func fetchSubscribeState() -> Single<[SubscribeStateEntity]>
}

final class RemoteNotificationsDataSourceImpl: RemoteBaseDataSource<NotificationsAPI>, RemoteNotificationsDataSource {
    public func fetchNotificationList() -> Single<[NotificationEntity]> {
        request(.fetchNotificationList)
            .map(NotificationListResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func patchReadNotification(id: Int) -> Completable {
        request(.patchReadNotification(id: id))
            .asCompletable()
    }

    func subscribeNotification(token: String, notificationType: NotificationType) -> Completable {
        request(.subscribeNotification(token: token, notificationType: notificationType))
            .asCompletable()
    }

    func subscribeAllNotification() -> Completable {
        request(.subscribeAllNotification)
            .asCompletable()
    }

    func fetchSubscribeState() -> RxSwift.Single<[Domain.SubscribeStateEntity]> {
        request(.fetchSubscribeState)
            .map(SubscribeStateListResponseDTO.self)
            .map { $0.toDomain() }
    }
}
