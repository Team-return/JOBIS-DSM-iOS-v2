import RxSwift
import Domain

protocol RemoteCompaniesDataSource {
    func fetchCompanyList(page: Int, name: String?, sortType: String?) -> Single<[CompanyEntity]>
    func fetchCompanyInfoDetail(id: Int) -> Single<CompanyInfoDetailEntity>
    func fetchWritableReviewList() -> Single<[WritableReviewCompanyEntity]>
    func fetchRecentCompanyList() -> Single<[RecentCompanyEntity]>
}

final class RemoteCompaniesDataSourceImpl: RemoteBaseDataSource<CompaniesAPI>, RemoteCompaniesDataSource {
    func fetchCompanyList(page: Int, name: String?, sortType: String?) -> Single<[CompanyEntity]> {
        request(.fetchCompanyList(page: page, name: name, sortType: sortType))
            .map(CompanyListResponseDTO.self)
            .map { $0.toDomain() }
    }

    func fetchCompanyInfoDetail(id: Int) -> Single<CompanyInfoDetailEntity> {
        request(.fetchCompanyInfoDetail(id: id))
            .map(CompanyInfoDetailResponseDTO.self)
            .map { $0.toDomain() }
    }

    func fetchWritableReviewList() -> Single<[WritableReviewCompanyEntity]> {
        request(.fetchWritableReviewList)
            .map(WritableReviewListResponseDTO.self)
            .map { $0.toDomain() }
    }

    func fetchRecentCompanyList() -> Single<[RecentCompanyEntity]> {
        request(.fetchRecentCompanyList)
            .map(RecentCompanyListResponseDTO.self)
            .map { $0.companies.map { $0.toDomain() } }
    }
}
