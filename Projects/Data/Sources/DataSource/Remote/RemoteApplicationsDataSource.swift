import RxSwift
import RxCocoa
import Foundation
import Domain

public protocol RemoteApplicationsDataSource {
    func applyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable
    func reApplyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable
    func cancelApply(id: String) -> Completable
    func fetchApplication() -> Single<[ApplicationEntity]>
    func fetchTotalPassStudent() -> Single<TotalPassStudentEntity>
    func fetchRejectionReason(id: String) -> Single<String>
}

final class RemoteApplicationsDataSourceImpl: RemoteBaseDataSource<ApplicationsAPI>, RemoteApplicationsDataSource {
    func applyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        request(.applyCompany(id: id, req))
            .asCompletable()
    }

    func reApplyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        request(.reApplyCompany(id: id, req))
            .asCompletable()
    }

    func cancelApply(id: String) -> Completable {
        request(.cancelApply(id: id))
            .asCompletable()
    }

    func fetchApplication() -> Single<[ApplicationEntity]> {
        request(.fetchApplication)
            .map(ApplicationListResponseDTO.self)
            .map { $0.toDomain() }
    }

    func fetchTotalPassStudent() -> Single<TotalPassStudentEntity> {
        request(.fetchTotalPassStudent)
            .map(TotalPassStudentResponseDTO.self)
            .map { $0.toDomain() }
    }

    func fetchRejectionReason(id: String) -> Single<String> {
        request(.fetchRejectionReason(id: id))
            .map(FetchRejectionReasonResponseDTO.self)
            .map { $0.rejectionReason }
    }
}
