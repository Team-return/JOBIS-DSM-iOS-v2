import RxSwift

public struct FetchRecruitmentListUseCase {
    public init(recruitmentsRepository: RecruitmentsRepository) {
        self.recruitmentsRepository = recruitmentsRepository
    }

    private let recruitmentsRepository: RecruitmentsRepository

    public func execute(
        page: Int,
        jobCode: String? = nil,
        techCode: [String]? = nil,
        name: String? = nil,
        winterIntern: Bool? = nil
    ) -> Single<[RecruitmentEntity]> {
        recruitmentsRepository.fetchRecruitmentList(
            page: page,
            jobCode: jobCode,
            techCode: techCode,
            name: name,
            winterIntern: winterIntern
        )
    }
}
