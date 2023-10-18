import Domain
import RxSwift
import RxCocoa

public struct ApplicationsRepositoryImpl: ApplicationsRepository {
    private let applicationsRemote: any ApplicationsRemote

    public init(
        applicationsRemote: any ApplicationsRemote
    ) {
        self.applicationsRemote = applicationsRemote
    }

    public func applyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        applicationsRemote.applyCompany(id: id, req: req )
    }

    public func cancelApply(id: String) -> Completable {
        applicationsRemote.cancelApply(id: id)
    }

    public func fetchApplication() -> Single<[ApplicationEntity]> {
        applicationsRemote.fetchApplication()
    }

    public func fetchTotalPassStudent() -> Single<TotalPassStudentEntity> {
        applicationsRemote.fetchTotalPassStudent()
    }
}
