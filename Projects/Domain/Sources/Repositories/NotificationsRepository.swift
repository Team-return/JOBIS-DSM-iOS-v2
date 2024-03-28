import RxSwift

public protocol NotificationsRepository {
    func fetchNotificationsList() -> Single<[NotificationEntity]>
    func patchReadNotification(id: Int) -> Completable
}
