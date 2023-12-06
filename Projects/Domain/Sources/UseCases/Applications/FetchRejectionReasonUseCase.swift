import RxSwift

public struct FetchRejectionReasonUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    func execute(id: String) -> Single<String> {
        applicationsRepository.fetchRejectionReason(id: id)
    }
}
