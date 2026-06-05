public struct SaveRecruitmentFilterUseCase {
    public init(recruitmentFilterRepository: RecruitmentFilterRepository) {
        self.recruitmentFilterRepository = recruitmentFilterRepository
    }

    private let recruitmentFilterRepository: RecruitmentFilterRepository

    public func execute(filter: RecruitmentFilterEntity) {
        recruitmentFilterRepository.saveRecruitmentFilter(filter)
    }
}
