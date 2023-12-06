import RxSwift
import Domain

struct CompaniesRepositoryImpl: CompaniesRepository {
    private let remoteCompaniesDataSource: any RemoteCompaniesDataSource

    init(remoteCompaniesDataSource: any RemoteCompaniesDataSource) {
        self.remoteCompaniesDataSource = remoteCompaniesDataSource
    }

    func fetchWritableReviewList() -> Single<[WritableReviewCompanyEntity]> {
        remoteCompaniesDataSource.fetchWritableReviewList()
    }

    func fetchCompanyInfoDetail(id: String) -> Single<CompanyInfoDetailEntity> {
        remoteCompaniesDataSource.fetchCompanyInfoDetail(id: id)
    }

    func fetchCompanyList(page: Int, name: String?) -> Single<[CompanyEntity]> {
        remoteCompaniesDataSource.fetchCompanyList(page: page, name: name)
    }
}
