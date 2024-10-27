import RxSwift

public struct FetchServerStatusUseCase {
    private let systemRepository: any SystemRepository

    public init(systemRepository: any SystemRepository) {
        self.systemRepository = systemRepository
    }

    public func execute() -> Completable {
        systemRepository.fetchServerStatus()
    }
}
