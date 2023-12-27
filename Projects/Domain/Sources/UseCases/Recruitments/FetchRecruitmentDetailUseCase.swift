import RxSwift

public struct FetchRecruitmentDetailUseCase {
    public init(recruitmentsRepository: RecruitmentsRepository) {
        self.recruitmentsRepository = recruitmentsRepository
    }

    private let recruitmentsRepository: RecruitmentsRepository

    public func execute(id: Int) -> Single<RecruitmentDetailEntity> {
        recruitmentsRepository.fetchRecruitmentDetail(id: id)
    }
}
