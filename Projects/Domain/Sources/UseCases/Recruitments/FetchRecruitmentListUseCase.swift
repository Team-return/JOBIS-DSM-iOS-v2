import RxSwift

public struct FetchRecruitmentListUseCase {
    public init(recruitmentsRepository: RecruitmentsRepository) {
        self.recruitmentsRepository = recruitmentsRepository
    }

    private let recruitmentsRepository: RecruitmentsRepository

    public func execute(
        page: Int, jobCode: String?, techCode: [String]?, name: String?
    ) -> Single<[RecruitmentEntity]> {
        recruitmentsRepository.fetchRecruitmentList(page: page, jobCode: jobCode, techCode: techCode, name: name)
    }
}
