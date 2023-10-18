import RxSwift

public struct ReportBugUseCase {
    public init(bugsRepository: BugsRepository) {
        self.bugsRepository = bugsRepository
    }

    private let bugsRepository: BugsRepository

    public func execute(req: ReportBugRequestQuery) -> Completable {
        bugsRepository.reportBug(req: req)
    }
}
