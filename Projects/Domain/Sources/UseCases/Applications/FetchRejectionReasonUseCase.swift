import RxSwift

public struct FetchRejectionReasonUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    public func execute(id: Int) -> Single<String> {
        applicationsRepository.fetchRejectionReason(id: id)
    }
}
