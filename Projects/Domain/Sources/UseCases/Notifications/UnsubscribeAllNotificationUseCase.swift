import RxSwift

public struct UnsubscribeAllNotificationUseCase {
    private let notificationsRepository: NotificationsRepository

    public init(notificationsRepository: NotificationsRepository) {
        self.notificationsRepository = notificationsRepository
    }

    public func execute(token: String) -> Completable {
        notificationsRepository.unsubscriptAllNotification(token: token)
    }
}
