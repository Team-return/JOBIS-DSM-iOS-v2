import RxSwift
import Domain

final class CompaniesRepositoryImpl: CompaniesRepository {
    private let companiesRemote: any CompaniesRemote

    init(companiesRemote: any CompaniesRemote) {
        self.companiesRemote = companiesRemote
    }

    func fetchWritableReviewList() -> Single<[WritableReviewCompanyEntity]> {
        companiesRemote.fetchWritableReviewList()
    }

    func fetchCompanyInfoDetail(id: String) -> Single<CompanyInfoDetailEntity> {
        companiesRemote.fetchCompanyInfoDetail(id: id)
    }

    func fetchCompanyList(page: Int, name: String?) -> Single<[CompanyEntity]> {
        companiesRemote.fetchCompanyList(page: page, name: name)
    }
}
