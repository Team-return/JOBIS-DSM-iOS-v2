import RxSwift
import Domain

struct BannersRepositoryImpl: BannersRepository {

    private let remoteBannersDataSource: any RemoteBannersDataSource

    init(
        remoteBannersDataSource: any RemoteBannersDataSource
    ) {
        self.remoteBannersDataSource = remoteBannersDataSource
    }

    func fetchBannerList() -> Single<[FetchBannerEntity]> {
        remoteBannersDataSource.fetchBannerList()
    }
}
