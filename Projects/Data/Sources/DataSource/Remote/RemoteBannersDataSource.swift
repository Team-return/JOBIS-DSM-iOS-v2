import RxSwift
import Domain

protocol RemoteBannersDataSource {
    func fetchBannerList() -> Single<[FetchBannerEntity]>
}

final class RemoteBannersDataSourceImpl: RemoteBaseDataSource<BannersAPI>, RemoteBannersDataSource {
    func fetchBannerList() -> RxSwift.Single<[Domain.FetchBannerEntity]> {
        request(.fetchBannerList)
            .map(FetchBannerListDTO.self)
            .map { $0.toDomain() }
    }
}
