import RxSwift
import RxCocoa

public struct CancelApplyUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    func execute(id: String) -> Completable {
        applicationsRepository.cancelApply(id: id)
    }
}
