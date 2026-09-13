import Domain

struct RecruitmentFilterRepositoryImpl: RecruitmentFilterRepository {
    private let localRecruitmentFilterDataSource: any LocalRecruitmentFilterDataSource

    init(localRecruitmentFilterDataSource: any LocalRecruitmentFilterDataSource) {
        self.localRecruitmentFilterDataSource = localRecruitmentFilterDataSource
    }

    func saveRecruitmentFilter(_ filter: RecruitmentFilterEntity) {
        localRecruitmentFilterDataSource.saveFilter(filter)
    }

    func fetchRecruitmentFilter() -> RecruitmentFilterEntity {
        localRecruitmentFilterDataSource.fetchFilter()
    }
}
