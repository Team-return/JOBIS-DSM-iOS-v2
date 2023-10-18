import RxSwift
import RxCocoa

public struct FetchTotalPassStudentUseCase {
    private let applicationRepository: any ApplicationsRepository

    public init(applicationRepository: any ApplicationsRepository) {
        self.applicationRepository = applicationRepository
    }

    func execute() -> Single<TotalPassStudentEntity> {
        applicationRepository.fetchTotalPassStudent()
    }
}
