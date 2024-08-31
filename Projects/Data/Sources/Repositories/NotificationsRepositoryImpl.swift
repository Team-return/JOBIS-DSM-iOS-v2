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
<<<<<<< Updated upstream
=======
<<<<<<< Updated upstream
=======
>>>>>>> Stashed changes

    func subscriptNotification(token: String, notificationType: NotificationType) -> Completable {
        remoteNotificationsDataSource.subscriptNotification(token: token, notificationType: notificationType)
    }
<<<<<<< Updated upstream
    
    func subscriptAllNotification(token: String) -> Completable {
        remoteNotificationsDataSource.subscriptAllNotification(token: token)
    }
=======

    func subscriptAllNotification(token: String) -> Completable {
        remoteNotificationsDataSource.subscriptAllNotification(token: token)
    }

    func unsubscriptNotification(token: String, notificationType: NotificationType) -> Completable {
        remoteNotificationsDataSource.unsubscriptNotification(token: token, notificationType: notificationType)
    }

    func unsubscriptAllNotification(token: String) -> Completable {
        remoteNotificationsDataSource.unsubscriptAllNotification(token: token)
    }
>>>>>>> Stashed changes
>>>>>>> Stashed changes
}
