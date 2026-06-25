public struct FetchRecruitmentFilterUseCase {
    public init(recruitmentFilterRepository: RecruitmentFilterRepository) {
        self.recruitmentFilterRepository = recruitmentFilterRepository
    }

    private let recruitmentFilterRepository: RecruitmentFilterRepository

    public func execute() -> RecruitmentFilterEntity {
        recruitmentFilterRepository.fetchRecruitmentFilter()
    }
}
