import RxSwift
import Domain

public protocol BugsRemote {
    func reportBug(req: ReportBugRequestQuery) -> Completable
    func fetchBugList(developmentArea: DevelopmentType) -> Single<[BugEntity]>
    func fetchBugDetail(id: Int) -> Single<BugDetailEntity>
}

final class BugsRemoteImpl: BaseRemote<BugsAPI>, BugsRemote {
    func reportBug(req: ReportBugRequestQuery) -> Completable {
        request(.reportBug(req))
            .asCompletable()
    }

    func fetchBugList(developmentArea: DevelopmentType) -> Single<[BugEntity]> {
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
