import RxSwift

public struct FetchEmploymentStatusUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    public func execute(year: Int) -> Single<[EmploymentEntity]> {
        applicationsRepository.fetchEmploymentStatus(year: year)
    }
}
