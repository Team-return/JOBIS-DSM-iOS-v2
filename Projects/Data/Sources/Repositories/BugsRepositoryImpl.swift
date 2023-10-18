import RxSwift
import Domain

final class BugsRepositoryImpl: BugsRepository {
    private let bugsRemote: any BugsRemote

    init(bugsRemote: any BugsRemote) {
        self.bugsRemote = bugsRemote
    }

    func reportBug(req: ReportBugRequestQuery) -> Completable {
        bugsRemote.reportBug(req: req)
    }

    func fetchBugList(developmentArea: DevelopmentType) -> Single<[BugEntity]> {
        bugsRemote.fetchBugList(developmentArea: developmentArea)
    }

    func fetchBugDetail(id: Int) -> Single<BugDetailEntity> {
        bugsRemote.fetchBugDetail(id: id)
    }
}
