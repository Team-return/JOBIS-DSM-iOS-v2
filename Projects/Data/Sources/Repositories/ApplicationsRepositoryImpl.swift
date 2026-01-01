import RxSwift
import Domain

struct ApplicationsRepositoryImpl: ApplicationsRepository {
    private let remoteApplicationsDataSource: any RemoteApplicationsDataSource

    init(remoteApplicationsDataSource: any RemoteApplicationsDataSource) {
        self.remoteApplicationsDataSource = remoteApplicationsDataSource
    }

    func applyCompany(id: Int, req: ApplyCompanyRequestQuery) -> Completable {
        remoteApplicationsDataSource.applyCompany(id: id, req: req)
    }

    func reApplyCompany(id: Int, req: ApplyCompanyRequestQuery) -> Completable {
        remoteApplicationsDataSource.reApplyCompany(id: id, req: req)
    }

    func cancelApply(id: Int) -> Completable {
        remoteApplicationsDataSource.cancelApply(id: id)
    }

    func fetchApplication() -> Single<[ApplicationEntity]> {
        remoteApplicationsDataSource.fetchApplication()
    }

    func fetchTotalPassStudent(year: Int) -> Single<TotalPassStudentEntity> {
        remoteApplicationsDataSource.fetchTotalPassStudent(year: year)
    }

    func fetchRejectionReason(id: Int) -> Single<String> {
        remoteApplicationsDataSource.fetchRejectionReason(id: id)
    }

    func fetchEmploymentStatus(year: Int) -> Single<[EmploymentEntity]> {
        remoteApplicationsDataSource.fetchEmploymentStatus(year: year)
    }
}
