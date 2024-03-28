import RxSwift

public struct FetchNotificationListUseCase {
    private let notificationsRepository: any NotificationsRepository

    public init(notificationsRepository: any NotificationsRepository) {
        self.notificationsRepository = notificationsRepository
    }

    public func execute() -> Single<[NotificationEntity]> {
        notificationsRepository.fetchNotificationsList()
    }
}
