import RxSwift

public protocol InterestsRepository {
    func updateInterests(interestsIDs: [Int]) -> Completable
}
