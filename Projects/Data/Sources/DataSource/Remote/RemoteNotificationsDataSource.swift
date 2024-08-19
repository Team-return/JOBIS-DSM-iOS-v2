import RxSwift
import RxCocoa
import Domain

public protocol RemoteNotificationsDataSource {
    func fetchNotificationList() -> Single<[NotificationEntity]>
    func patchReadNotification(id: Int) -> Completable
    func subscriptNotification(token: String, notificationType: NotificationType) -> Completable
    func subscriptAllNotification(token: String) -> Completable
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

    func subscriptNotification(token: String, notificationType: NotificationType) -> Completable {
        request(.subscriptNotification(token: token, notificationType: notificationType))
            .asCompletable()
    }
    
    func subscriptAllNotification(token: String) -> Completable {
        request(.subscriptAllNotification(token: token))
            .asCompletable()
    }
}
