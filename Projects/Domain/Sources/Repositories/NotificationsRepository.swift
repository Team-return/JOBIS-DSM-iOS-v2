import RxSwift

public protocol NotificationsRepository {
    func fetchNotificationsList() -> Single<[NotificationEntity]>
    func patchReadNotification(id: Int) -> Completable
    func subscriptNotification(token: String, notificationType: NotificationType) -> Completable
    func subscriptAllNotification(token: String) -> Completable
}
