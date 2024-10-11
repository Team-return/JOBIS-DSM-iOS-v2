import RxSwift

public struct FetchSubscribeStateUseCase {
    private let notificationsRepository: NotificationsRepository

    public init(notificationsRepository: NotificationsRepository) {
        self.notificationsRepository = notificationsRepository
    }

    public func execute() -> Single<[SubscribeStateEntity]> {
        notificationsRepository.fetchSubscribeState()
    }
}
