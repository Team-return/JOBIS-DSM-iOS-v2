import RxCocoa
import RxSwift

public struct ApplyCompanyUseCase {
    private let applicationRepository: any ApplicationsRepository

    public init(applicationRepository: any ApplicationsRepository) {
        self.applicationRepository = applicationRepository
    }

    func execute(id: String, req: ApplyCompanyRequestQuery) -> Completable {
        applicationRepository.applyCompany(id: id, req: req)
    }
}
