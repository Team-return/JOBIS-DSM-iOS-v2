import RxSwift

public struct FetchCompanyInfoDetailUseCase {
    public init(companiesRepository: CompaniesRepository) {
        self.companiesRepository = companiesRepository
    }

    private let companiesRepository: CompaniesRepository

    public func execute(id: String) -> Single<CompanyInfoDetailEntity> {
        return companiesRepository.fetchCompanyInfoDetail(id: id)
    }
}
