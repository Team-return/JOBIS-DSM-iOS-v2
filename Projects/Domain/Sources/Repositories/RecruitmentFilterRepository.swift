public protocol RecruitmentFilterRepository {
    func saveRecruitmentFilter(_ filter: RecruitmentFilterEntity)
    func fetchRecruitmentFilter() -> RecruitmentFilterEntity
}
