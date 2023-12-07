import RxSwift

public struct FetchTotalPassStudentUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    func execute() -> Single<TotalPassStudentEntity> {
        applicationsRepository.fetchTotalPassStudent()
    }
}
