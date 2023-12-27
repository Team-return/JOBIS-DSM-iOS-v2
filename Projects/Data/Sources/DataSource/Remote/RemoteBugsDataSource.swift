import RxSwift
import Domain

public protocol RemoteBugsDataSource {
    func reportBug(req: ReportBugRequestQuery) -> Completable
    func fetchBugList(developmentArea: DevelopmentType) -> Single<[BugReportEntity]>
    func fetchBugDetail(id: Int) -> Single<BugDetailEntity>
}

final class RemoteBugsDataSourceImpl: RemoteBaseDataSource<BugsAPI>, RemoteBugsDataSource {
    func reportBug(req: ReportBugRequestQuery) -> Completable {
        request(.reportBug(req))
            .asCompletable()
    }

    func fetchBugList(developmentArea: DevelopmentType) -> Single<[BugReportEntity]> {
        request(.fetchBugList(developmentArea))
            .map(BugListResponseDTO.self)
            .map { $0.toDomain() }
    }

    func fetchBugDetail(id: Int) -> Single<BugDetailEntity> {
        request(.fetchBugDetail(id: id))
            .map(BugDetailResponseDTO.self)
            .map { $0.toDomain() }
    }
}
