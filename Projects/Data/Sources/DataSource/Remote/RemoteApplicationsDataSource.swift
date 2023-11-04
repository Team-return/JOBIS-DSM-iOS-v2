import RxSwift
import RxCocoa
import Foundation
import Domain

public protocol RemoteApplicationsDataSource {
    func applyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable
    func cancelApply(id: String) -> Completable
    func fetchApplication() -> Single<[ApplicationEntity]>
    func fetchTotalPassStudent() -> Single<TotalPassStudentEntity>
}

final class RemoteApplicationsDataSourceImpl: RemoteBaseDataSource<ApplicationsAPI>, RemoteApplicationsDataSource {
    func applyCompany(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        request(.applyCompany(id: id, req))
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
}
