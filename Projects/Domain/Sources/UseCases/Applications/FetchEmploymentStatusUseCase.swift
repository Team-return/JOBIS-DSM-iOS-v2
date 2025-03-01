import RxSwift

public struct FetchEmploymentStatusUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    public func execute() -> Single<[ApplicationEntity]> {
        applicationsRepository.fetchEmploymentStatus()
    }
}
