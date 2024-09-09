import RxSwift
import Domain

struct NotificationsRepositoryImpl: NotificationsRepository {
    private let remoteNotificationsDataSource: any RemoteNotificationsDataSource

    init(
        remoteNotificationsDataSource: any RemoteNotificationsDataSource
    ) {
        self.remoteNotificationsDataSource = remoteNotificationsDataSource
    }

    func fetchNotificationsList() -> Single<[NotificationEntity]> {
        remoteNotificationsDataSource.fetchNotificationList()
    }

    func patchReadNotification(id: Int) -> Completable {
        remoteNotificationsDataSource.patchReadNotification(id: id)
    }

    func subscribeNotification(token: String, notificationType: NotificationType) -> Completable {
        remoteNotificationsDataSource.subscribeNotification(token: token, notificationType: notificationType)
    }

    func subscribeAllNotification() -> Completable {
        remoteNotificationsDataSource.subscribeAllNotification()
    }

    func fetchSubscribeState() -> Single<[SubscribeStateEntity]> {
        remoteNotificationsDataSource.fetchSubscribeState()
    }
}
