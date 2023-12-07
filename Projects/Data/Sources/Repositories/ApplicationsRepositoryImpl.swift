import RxSwift
import Domain

struct ApplicationsRepositoryImpl: ApplicationsRepository {
    private let remoteApplicationsDataSource: any RemoteApplicationsDataSource

    init(remoteApplicationsDataSource: any RemoteApplicationsDataSource) {
        self.remoteApplicationsDataSource = remoteApplicationsDataSource
    }

    func applyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        remoteApplicationsDataSource.applyCompany(id: id, req: req)
    }

    func reApplyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        remoteApplicationsDataSource.reApplyCompany(id: id, req: req)
    }

    func cancelApply(id: String) -> Completable {
        remoteApplicationsDataSource.cancelApply(id: id)
    }

    func fetchApplication() -> Single<[ApplicationEntity]> {
        remoteApplicationsDataSource.fetchApplication()
    }

    func fetchTotalPassStudent() -> Single<TotalPassStudentEntity> {
        remoteApplicationsDataSource.fetchTotalPassStudent()
    }

    func fetchRejectionReason(id: String) -> Single<String> {
        remoteApplicationsDataSource.fetchRejectionReason(id: id)
    }
}
