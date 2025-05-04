import RxSwift

public struct FetchInterestsUseCase {
    private let interestsRepository: any InterestsRepository

    public init(interestsRepository: any InterestsRepository) {
        self.interestsRepository = interestsRepository
    }

    public func execute() -> Single<[InterestsEntity]> {
        interestsRepository.fetchInterests()
    }
}
