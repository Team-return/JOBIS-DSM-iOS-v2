import RxSwift

public struct ApplyCompanyUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    func execute(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        applicationsRepository.applyCompany(id: id, req: req)
    }
}
