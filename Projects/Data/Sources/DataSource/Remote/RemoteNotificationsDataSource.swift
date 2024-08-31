import RxSwift
import RxCocoa
import Domain

public protocol RemoteNotificationsDataSource {
    func fetchNotificationList() -> Single<[NotificationEntity]>
    func patchReadNotification(id: Int) -> Completable
<<<<<<< Updated upstream
    func subscriptNotification(token: String, notificationType: NotificationType) -> Completable
    func subscriptAllNotification(token: String) -> Completable
=======
<<<<<<< Updated upstream
=======
    func subscriptNotification(token: String, notificationType: NotificationType) -> Completable
    func subscriptAllNotification(token: String) -> Completable
    func unsubscriptNotification(token: String, notificationType: NotificationType) -> Completable
    func unsubscriptAllNotification(token: String) -> Completable
>>>>>>> Stashed changes
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
<<<<<<< Updated upstream
=======
>>>>>>> Stashed changes

    func subscriptNotification(token: String, notificationType: NotificationType) -> Completable {
        request(.subscriptNotification(token: token, notificationType: notificationType))
            .asCompletable()
    }
<<<<<<< Updated upstream
    
=======

>>>>>>> Stashed changes
    func subscriptAllNotification(token: String) -> Completable {
        request(.subscriptAllNotification(token: token))
            .asCompletable()
    }
<<<<<<< Updated upstream
=======

    func unsubscriptNotification(token: String, notificationType: Domain.NotificationType) -> RxSwift.Completable {
        request(.subscriptNotification(token: token, notificationType: notificationType))
            .asCompletable()
    }
    
    func unsubscriptAllNotification(token: String) -> RxSwift.Completable {
        request(.unsubscriptAllNotification(token: token))
            .asCompletable()
    }
>>>>>>> Stashed changes
>>>>>>> Stashed changes
}
