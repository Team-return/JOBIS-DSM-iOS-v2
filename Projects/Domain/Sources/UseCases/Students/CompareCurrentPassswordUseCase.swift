import RxSwift

public struct CompareCurrentPasswordUseCase {
    private let studentsRepository: any StudentsRepository

    public init(studentsRepository: any StudentsRepository) {
        self.studentsRepository = studentsRepository
    }

    public func execute(password: String) -> Completable {
        studentsRepository.compareCurrentPassword(password: password)
    }
}
