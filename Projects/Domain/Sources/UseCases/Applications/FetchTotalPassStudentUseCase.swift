import RxSwift

public struct FetchTotalPassStudentUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    public func execute() -> Single<TotalPassStudentEntity> {
        applicationsRepository.fetchTotalPassStudent()
    }
}
