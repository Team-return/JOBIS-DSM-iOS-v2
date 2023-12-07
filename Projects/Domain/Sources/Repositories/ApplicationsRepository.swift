import RxSwift

public protocol ApplicationsRepository {
    func applyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable
    func reApplyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable
    func cancelApply(id: String) -> Completable
    func fetchApplication() -> Single<[ApplicationEntity]>
    func fetchTotalPassStudent() -> Single<TotalPassStudentEntity>
    func fetchRejectionReason(id: String) -> Single<String>
}
