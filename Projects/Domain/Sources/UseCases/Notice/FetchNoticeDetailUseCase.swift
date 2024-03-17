import RxSwift

public struct FetchNoticeDetailUseCase {
    private let noticesRepository: any NoticesRepository

    public init(noticesRepository: NoticesRepository) {
        self.noticesRepository = noticesRepository
    }

    public func execute(id: Int) -> Single<NoticeDetailEntity> {
        return noticesRepository.fetchNotcieDetail(id: id)
    }
}
