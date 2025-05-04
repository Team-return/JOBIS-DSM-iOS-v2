import RxSwift

public struct ChangeInterestsUseCase {
    public init(interestsRepository: any InterestsRepository) {
        self.interestsRepository = interestsRepository
    }

    private let interestsRepository: any InterestsRepository

    public func execute(interests: [InterestsEntity]) -> Completable {
        interestsRepository.updateInterests(interestsIDs: interests.map { $0.code })
    }
}
