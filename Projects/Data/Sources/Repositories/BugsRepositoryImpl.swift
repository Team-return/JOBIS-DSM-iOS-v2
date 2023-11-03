import RxSwift
import Domain

final class BugsRepositoryImpl: BugsRepository {
    private let remoteBugsDataSource: any RemoteBugsDataSource

    init(remoteBugsDataSource: any RemoteBugsDataSource) {
        self.remoteBugsDataSource = remoteBugsDataSource
    }

    func reportBug(req: ReportBugRequestQuery) -> Completable {
        remoteBugsDataSource.reportBug(req: req)
    }

    func fetchBugList(developmentArea: DevelopmentType) -> Single<[BugEntity]> {
        remoteBugsDataSource.fetchBugList(developmentArea: developmentArea)
    }

    func fetchBugDetail(id: Int) -> Single<BugDetailEntity> {
        remoteBugsDataSource.fetchBugDetail(id: id)
    }
}
