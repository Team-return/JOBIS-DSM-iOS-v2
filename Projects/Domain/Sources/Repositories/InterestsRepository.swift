import RxSwift

public protocol InterestsRepository {
    func fetchInterests() -> Single<[InterestsEntity]>
}
