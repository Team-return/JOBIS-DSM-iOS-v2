import RxSwift

public struct ApplyCompanyUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    public func execute(id: Int, req: ApplyCompanyRequestQuery) -> Completable {
        applicationsRepository.applyCompany(id: id, req: req)
    }
}
