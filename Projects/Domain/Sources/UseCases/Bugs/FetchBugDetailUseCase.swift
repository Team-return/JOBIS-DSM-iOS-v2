import RxSwift

public struct FetchBugDetailUseCase {
    public init(bugsRepository: BugsRepository) {
        self.bugsRepository = bugsRepository
    }

    private let bugsRepository: BugsRepository

    public func execute(id: Int) -> Single<BugDetailEntity> {
        bugsRepository.fetchBugDetail(id: id)
    }
}
