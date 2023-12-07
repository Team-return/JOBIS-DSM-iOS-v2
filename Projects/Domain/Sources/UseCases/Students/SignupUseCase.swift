import RxSwift

public struct SignupUseCase {
    private let studentsRepository: any StudentsRepository

    public init(studentsRepository: any StudentsRepository) {
        self.studentsRepository = studentsRepository
    }

    public func execute(req: SignupRequestQuery) -> Completable {
        studentsRepository.signup(req: req)
    }
}
