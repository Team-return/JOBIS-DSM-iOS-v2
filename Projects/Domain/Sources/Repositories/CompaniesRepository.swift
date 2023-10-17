import RxSwift

public protocol CompaniesRepository {
    func fetchCompanyList(page: Int, name: String?) -> Single<[CompanyEntity]>
    func fetchCompanyInfoDetail(id: String) -> Single<CompanyInfoDetailEntity>
    func fetchWritableReviewList() -> Single<[WritableReviewCompanyEntity]>
}
