import RxSwift

public struct ReadNotificationUseCase {
    private let notificationsRepository: any NotificationsRepository

    public init(notificationsRepository: any NotificationsRepository) {
        self.notificationsRepository = notificationsRepository
    }

    public func execute(id: Int) -> Completable {
        notificationsRepository.patchReadNotification(id: id)
    }
}
