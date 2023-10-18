import RxSwift
import RxCocoa
import Foundation

public protocol ApplicationsRepository {
    func applyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable
    func cancelApply(id: String) -> Completable
    func fetchApplication() -> Single<[ApplicationEntity]>
    func fetchTotalPassStudent() -> Single<TotalPassStudentEntity>
}
