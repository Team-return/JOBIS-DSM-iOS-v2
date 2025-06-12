import RxSwift
import Domain

struct InterestsRepositoryImpl: InterestsRepository {
    private let remoteInterestsDataSource: any RemoteInterestsDataSource

    init(remoteInterestsDataSource: any RemoteInterestsDataSource) {
        self.remoteInterestsDataSource = remoteInterestsDataSource
    }

    func updateInterests(interestsIDs: [Int]) -> Completable {
        remoteInterestsDataSource.updateInterests(interestsIDs: interestsIDs)
    }
}
