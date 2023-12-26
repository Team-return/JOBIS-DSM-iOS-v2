import RxSwift

public struct ReApplyCompanyUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    func execute(id: Int, req: ApplyCompanyRequestQuery) -> Completable {
        applicationsRepository.reApplyCompany(id: id, req: req)
    }
}
