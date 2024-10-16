import RxSwift

public struct FetchWinterInternSeasonUseCase {
    private let winterInternRepository: any WinterInternRepository

    public init(winterInternRepository: any WinterInternRepository) {
        self.winterInternRepository = winterInternRepository
    }

    public func execute() -> Single<Bool> {
        winterInternRepository.fetchWinterInternSeason()
    }
}
