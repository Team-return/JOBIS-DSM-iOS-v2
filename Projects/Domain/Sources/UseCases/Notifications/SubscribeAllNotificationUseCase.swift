import RxSwift

public struct SubscribeAllNotificationUseCase {
    private let notificationsRepository: NotificationsRepository

    public init(notificationsRepository: NotificationsRepository) {
        self.notificationsRepository = notificationsRepository
    }

    public func execute(token: String) -> Completable {
        notificationsRepository.subscriptAllNotification(token: token)
    }
}
