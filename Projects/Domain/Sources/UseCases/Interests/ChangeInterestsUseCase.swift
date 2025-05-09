import RxSwift

public struct ChangeInterestsUseCase {
    private let interestsRepository: any InterestsRepository

    public init(interestsRepository: any InterestsRepository) {
        self.interestsRepository = interestsRepository
    }

    public func execute(interests: [InterestsEntity]) -> Completable {
        interestsRepository.updateInterests(interestsIDs: interests.map { $0.interestID })
    }
}
