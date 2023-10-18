import RxSwift
import RxCocoa

public struct CancelApplyUseCase {
    private let applicationRepository: any ApplicationsRepository

    public init(applicationRepository: any ApplicationsRepository) {
        self.applicationRepository = applicationRepository
    }
    func execute(id: String) -> Completable {
        applicationRepository.cancelApply(id: id)
    }
}
