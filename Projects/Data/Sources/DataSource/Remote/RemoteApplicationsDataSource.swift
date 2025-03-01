import RxSwift
import RxCocoa
import Foundation
import Domain

public protocol RemoteApplicationsDataSource {
    func applyCompany(id: Int, req: ApplyCompanyRequestQuery) -> Completable
    func reApplyCompany(id: Int, req: ApplyCompanyRequestQuery) -> Completable
    func cancelApply(id: Int) -> Completable
    func fetchApplication() -> Single<[ApplicationEntity]>
    func fetchTotalPassStudent() -> Single<TotalPassStudentEntity>
    func fetchRejectionReason(id: Int) -> Single<String>
    func fetchEmploymentStatus() -> Single<[ApplicationEntity]>
}

final class RemoteApplicationsDataSourceImpl: RemoteBaseDataSource<ApplicationsAPI>, RemoteApplicationsDataSource {
    func applyCompany(id: Int, req: ApplyCompanyRequestQuery) -> Completable {
        request(.applyCompany(id: id, req))
            .asCompletable()
    }

    func reApplyCompany(id: Int, req: ApplyCompanyRequestQuery) -> Completable {
        request(.reApplyCompany(id: id, req))
            .asCompletable()
    }

    func cancelApply(id: Int) -> Completable {
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

    func fetchRejectionReason(id: Int) -> Single<String> {
        request(.fetchRejectionReason(id: id))
            .map(FetchRejectionReasonResponseDTO.self)
            .map { $0.rejectionReason }
    }
    func fetchEmploymentStatus() -> Single<[ApplicationEntity]> {
        request(.fetchEmploymentStatus)
            .map(ClassEmploymentListResponseDTO.self)
            .map { $0.toDomain() }
    }
}
