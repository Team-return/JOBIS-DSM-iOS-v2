import RxSwift
import RxCocoa

public struct StudentExistsUseCase {
    private let studentsRepository: any StudentsRepository

    public init(studentsRepository: any StudentsRepository) {
        self.studentsRepository = studentsRepository
    }

    public func execute(gcn: Int, name: String) -> Completable {
        studentsRepository.studentExists(gcn: gcn, name: name)
    }
}
