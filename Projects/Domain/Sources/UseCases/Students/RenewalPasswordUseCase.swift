import RxSwift

public struct RenewalPasswordUseCase {
    private let studentsRepository: any StudentsRepository

    public init(studentsRepository: any StudentsRepository) {
        self.studentsRepository = studentsRepository
    }

    public func execute(req: RenewalPasswordRequestQuery) -> Completable {
        studentsRepository.renewalPassword(req: req)
    }
}
