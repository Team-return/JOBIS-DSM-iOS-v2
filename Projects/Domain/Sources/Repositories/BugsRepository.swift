import RxSwift

public protocol BugsRepository {
    func reportBug(req: ReportBugRequestQuery) -> Completable
    func fetchBugList(developmentArea: DevelopmentType) -> Single<[BugReportEntity]>
    func fetchBugDetail(id: Int) -> Single<BugDetailEntity>
}
