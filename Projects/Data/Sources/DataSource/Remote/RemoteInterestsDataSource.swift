import RxSwift
import RxCocoa
import Foundation
import Domain

public protocol RemoteInterestsDataSource {
    func updateInterests(interestsIDs: [Int]) -> Completable
}

final class RemoteInterestsDataSourceImpl: RemoteBaseDataSource<InterestsAPI>, RemoteInterestsDataSource {
    func updateInterests(interestsIDs: [Int]) -> Completable {
        request(.updateInterests(interestsIDs: interestsIDs))
            .asCompletable()
    }
}
