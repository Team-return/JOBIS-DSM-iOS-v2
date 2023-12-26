import RxSwift

public struct FetchBugListUseCase {
    public init(bugsRepository: BugsRepository) {
        self.bugsRepository = bugsRepository
    }

    private let bugsRepository: BugsRepository

    public func execute(developmentArea: DevelopmentType) -> Single<[BugReportEntity]> {
        bugsRepository.fetchBugList(developmentArea: developmentArea)
    }
}
