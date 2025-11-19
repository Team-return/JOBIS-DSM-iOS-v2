import RxSwift

public struct FetchTotalPassStudentUseCase {
    private let applicationsRepository: any ApplicationsRepository

    public init(applicationsRepository: any ApplicationsRepository) {
        self.applicationsRepository = applicationsRepository
    }

    public func execute(year: Int) -> Single<TotalPassStudentEntity> {
        applicationsRepository.fetchTotalPassStudent(year: year)
    }
}
