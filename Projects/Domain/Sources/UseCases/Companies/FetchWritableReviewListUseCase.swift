import RxSwift

public struct FetchWritableReviewListUseCase {
    public init(companiesRepository: CompaniesRepository) {
        self.companiesRepository = companiesRepository
    }

    private let companiesRepository: CompaniesRepository

    public func execute() -> Single<[WritableReviewCompanyEntity]> {
        return companiesRepository.fetchWritableReviewList()
    }
}
