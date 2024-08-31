import RxSwift

public protocol NotificationsRepository {
    func fetchNotificationsList() -> Single<[NotificationEntity]>
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
