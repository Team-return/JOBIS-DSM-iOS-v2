import RxSwift
import Domain

struct SystemRepositoryImpl: SystemRepository {
    private let remoteSystemDataSource: any RemoteSystemDataSource

    init(remoteSystemDataSource: any RemoteSystemDataSource) {
        self.remoteSystemDataSource = remoteSystemDataSource
    }

    func fetchServerStatus() -> Completable {
        remoteSystemDataSource.fetchServerStatus()
    }

}
