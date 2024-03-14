import RxSwift

public protocol BannersRepository {
    func fetchBannerList() -> Single<[FetchBannerEntity]>
}
