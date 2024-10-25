import RxSwift
import Domain

protocol RemoteSystemDataSource {
    func fetchServerStatus() -> Completable
}

final class RemoteSystemDataSourceImpl: RemoteBaseDataSource<SystemAPI>, RemoteSystemDataSource {
    func fetchServerStatus() -> Completable {
        request(.fetchServerStatus)
            .asCompletable()
    }
}
