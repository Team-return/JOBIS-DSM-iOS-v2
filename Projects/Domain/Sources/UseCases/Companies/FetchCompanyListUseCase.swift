import RxSwift

public struct FetchCompanyListUseCase {
    public init(companiesRepository: CompaniesRepository) {
        self.companiesRepository = companiesRepository
    }

    private let companiesRepository: CompaniesRepository

    public func execute(page: Int, name: String? = nil) -> Single<[CompanyEntity]> {
        return companiesRepository.fetchCompanyList(page: page, name: name)
    }
}
