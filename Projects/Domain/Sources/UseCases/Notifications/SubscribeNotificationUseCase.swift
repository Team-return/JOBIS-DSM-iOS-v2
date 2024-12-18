import RxSwift

public struct SubscribeNotificationUseCase {
    private let notificationsRepository: NotificationsRepository

    public init(notificationsRepository: NotificationsRepository) {
        self.notificationsRepository = notificationsRepository
    }

    public func execute(token: String, notificationType: NotificationType) -> Completable {
        notificationsRepository.subscribeNotification(token: token, notificationType: notificationType)
    }
}
