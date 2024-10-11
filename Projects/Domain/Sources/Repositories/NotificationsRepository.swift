import RxSwift

public protocol NotificationsRepository {
    func fetchNotificationsList() -> Single<[NotificationEntity]>
    func patchReadNotification(id: Int) -> Completable
    func subscribeNotification(token: String, notificationType: NotificationType) -> Completable
    func subscribeAllNotification() -> Completable
    func fetchSubscribeState() -> Single<[SubscribeStateEntity]>
}
