import RxSwift

public struct FetchBannerListUseCase {
    private let bannersRepository: any BannersRepository

    public init(bannersRepository: any BannersRepository) {
        self.bannersRepository = bannersRepository
    }

    public func execute() -> Single<[FetchBannerEntity]> {
        bannersRepository.fetchBannerList()
    }
}
