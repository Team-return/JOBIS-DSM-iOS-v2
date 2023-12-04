import Domain
import RxSwift
import RxCocoa

public struct ApplicationsRepositoryImpl: ApplicationsRepository {
    private let remoteApplicationsDataSource: any RemoteApplicationsDataSource

    init(remoteApplicationsDataSource: any RemoteApplicationsDataSource) {
        self.remoteApplicationsDataSource = remoteApplicationsDataSource
    }

    public func applyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        remoteApplicationsDataSource.applyCompany(id: id, req: req)
    }

    public func reApplyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        remoteApplicationsDataSource.reApplyCompany(id: id, req: req)
    }

    public func cancelApply(id: String) -> Completable {
        remoteApplicationsDataSource.cancelApply(id: id)
    }

    public func fetchApplication() -> Single<[ApplicationEntity]> {
        remoteApplicationsDataSource.fetchApplication()
    }

    public func fetchTotalPassStudent() -> Single<TotalPassStudentEntity> {
        remoteApplicationsDataSource.fetchTotalPassStudent()
    }
}
