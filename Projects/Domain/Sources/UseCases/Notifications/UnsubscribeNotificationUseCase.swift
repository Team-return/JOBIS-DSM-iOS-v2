import RxSwift

public struct UnsubscribeNotificationUseCase {
    private let notificationsRepository: NotificationsRepository

    public init(notificationsRepository: NotificationsRepository) {
        self.notificationsRepository = notificationsRepository
    }

    public func execute(token: String, notificationType: NotificationType) -> Completable {
        notificationsRepository.unsubscriptNotification(token: token, notificationType: notificationType)
    }
}
