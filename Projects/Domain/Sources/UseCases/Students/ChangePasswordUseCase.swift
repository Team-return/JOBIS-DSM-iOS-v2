import RxSwift

public struct ChangePasswordUseCase {
    private let studentsRepository: any StudentsRepository

    public init(studentsRepository: any StudentsRepository) {
        self.studentsRepository = studentsRepository
    }

    public func execute(req: ChangePasswordRequestQuery) -> Completable {
        studentsRepository.changePassword(req: req)
    }
}
