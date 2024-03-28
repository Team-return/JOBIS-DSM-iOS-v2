import RxSwift
import RxCocoa
import Domain

public protocol RemoteNotificationsDataSource {
    func fetchNotificationList() -> Single<[NotificationEntity]>
    func patchReadNotification(id: Int) -> Completable
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
}
