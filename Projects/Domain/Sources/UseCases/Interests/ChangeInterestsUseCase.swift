import RxSwift

public struct ChangeInterestsUseCase {
    private let interestsRepository: any InterestsRepository

    public init(interestsRepository: any InterestsRepository) {
        self.interestsRepository = interestsRepository
    }

    public func execute(interests: [InterestsEntity]) -> Completable {
        interestsRepository.updateInterests(interestsIDs: interests.map { $0.code })
    }

    public func execute(codeIDs: [Int]) -> Completable {
        interestsRepository.updateInterests(interestsIDs: codeIDs)
    }
}
