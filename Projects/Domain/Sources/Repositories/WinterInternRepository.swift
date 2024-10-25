import RxSwift

public protocol WinterInternRepository {
    func fetchWinterInternSeason() -> Single<Bool>
}
