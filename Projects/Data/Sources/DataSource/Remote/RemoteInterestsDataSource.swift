import RxSwift
import RxCocoa
import Foundation
import Domain

public protocol RemoteInterestsDataSource {
    func fetchInterests() -> Single<[InterestsEntity]>
    func updateInterests(interestsIDs: [Int]) -> Completable
}

final class RemoteInterestsDataSourceImpl: RemoteBaseDataSource<InterestsAPI>, RemoteInterestsDataSource {
    func fetchInterests() -> Single<[InterestsEntity]> {
        request(.fetchInterests)
            .map([InterestResponseDTO].self)
            .map { $0.toDomain() }
    }

    func updateInterests(interestsIDs: [Int]) -> Completable {
        request(.updateInterests(interestsIDs: interestsIDs))
            .asCompletable()
    }
}
