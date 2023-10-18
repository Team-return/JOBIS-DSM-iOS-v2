import RxSwift

public protocol BugsRepository {
    func reportBug(req: ReportBugRequestQuery) -> Completable
    func fetchBugList(developmentArea: DevelopmentType) -> Single<[BugEntity]>
    func fetchBugDetail(id: Int) -> Single<BugDetailEntity>
}
