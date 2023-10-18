import RxSwift
import RxCocoa

public struct FetchApplicationUseCase {
    private let applicationRepository: any ApplicationsRepository

    public init(applicationRepository: any ApplicationsRepository) {
        self.applicationRepository = applicationRepository
    }

    func execute() -> Single<[ApplicationEntity]> {
        applicationRepository.fetchApplication()
    }
}
