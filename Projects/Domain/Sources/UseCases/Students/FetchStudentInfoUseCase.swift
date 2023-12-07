import RxSwift

public struct FetchStudentInfoUseCase {
    private let studentsRepository: any StudentsRepository

    public init(studentsRepository: any StudentsRepository) {
        self.studentsRepository = studentsRepository
    }

    public func execute() -> Single<StudentInfoEntity> {
        studentsRepository.fetchStudentInfo()
    }
}
