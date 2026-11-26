import RxSwift

public struct CancelApplyUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    public func execute(id: Int) -> Completable {
        applicationsRepository.cancelApply(id: id)
    }
}
