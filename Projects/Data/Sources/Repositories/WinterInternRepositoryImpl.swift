import RxSwift
import Domain

struct WinterInternRepositoryImpl: WinterInternRepository {
    private let remoteWinterInternDataSource: any RemoteWinterInternDataSource

    init(remoteWinterInternDataSource: any RemoteWinterInternDataSource) {
        self.remoteWinterInternDataSource = remoteWinterInternDataSource
    }

    func fetchWinterInternSeason() -> Single<Bool> {
        remoteWinterInternDataSource.fetchWinterInternSeason()
    }
}
