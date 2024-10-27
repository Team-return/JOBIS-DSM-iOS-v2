import RxSwift

public protocol SystemRepository {
    func fetchServerStatus() -> Completable
}
