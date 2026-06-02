import RxSwift

public protocol CompaniesRepository {
    func fetchCompanyList(page: Int, name: String?, sortType: String?) -> Single<[CompanyEntity]>
    func fetchCompanyInfoDetail(id: Int) -> Single<CompanyInfoDetailEntity>
    func fetchWritableReviewList() -> Single<[WritableReviewCompanyEntity]>
    func fetchRecentCompanyList() -> Single<[RecentCompanyEntity]>
}
