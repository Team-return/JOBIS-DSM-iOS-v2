import RxSwift

public protocol InterestsRepository {
    func fetchInterests() -> Single<[InterestsEntity]>
    func updateInterests(interestsIDs: [Int]) -> Completable
}
