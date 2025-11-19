import RxSwift

public protocol ApplicationsRepository {
    func applyCompany(id: Int, req: ApplyCompanyRequestQuery) -> Completable
    func reApplyCompany(id: Int, req: ApplyCompanyRequestQuery) -> Completable
    func cancelApply(id: Int) -> Completable
    func fetchApplication() -> Single<[ApplicationEntity]>
    func fetchTotalPassStudent(year: Int) -> Single<TotalPassStudentEntity>
    func fetchRejectionReason(id: Int) -> Single<String>
    func fetchEmploymentStatus() -> Single<[EmploymentEntity]>
}
