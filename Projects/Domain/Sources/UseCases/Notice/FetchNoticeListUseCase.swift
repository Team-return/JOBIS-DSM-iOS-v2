import RxSwift

public struct FetchNoticeListUseCase {
    private let noticesRepository: any NoticesRepository

    public init(noticesRepository: NoticesRepository) {
        self.noticesRepository = noticesRepository
    }

    public func execute() -> Single<[NoticeEntity]> {
        return noticesRepository.fetchNoticeList()
    }
}
