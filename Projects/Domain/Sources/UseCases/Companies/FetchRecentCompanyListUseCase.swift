import RxSwift

public struct FetchRecentCompanyListUseCase {
    public init(companiesRepository: CompaniesRepository) {
        self.companiesRepository = companiesRepository
    }
    
    private let companiesRepository: CompaniesRepository
    
    public func execute() -> Single<[RecentCompanyEntity]> {
        return companiesRepository.fetchRecentCompanyList()
    }
}
