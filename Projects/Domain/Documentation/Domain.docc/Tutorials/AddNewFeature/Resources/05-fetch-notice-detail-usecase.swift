import RxSwift

// UseCase는 단일 책임: execute() 하나만 노출합니다.
// Repository는 생성자 주입(Swinject)으로 받습니다.
public struct FetchNoticeDetailUseCase {
    private let noticesRepository: any NoticesRepository

    public init(noticesRepository: any NoticesRepository) {
        self.noticesRepository = noticesRepository
    }

    public func execute(id: Int) -> Single<NoticeDetailEntity> {
        return noticesRepository.fetchNoticeDetail(id: id)
    }
}
