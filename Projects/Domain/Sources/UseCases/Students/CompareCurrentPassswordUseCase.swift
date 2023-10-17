import RxSwift
import RxCocoa

public struct CompareCurrentPassswordUseCase {
    private let studentsRepository: any StudentsRepository

    public init(studentsRepository: any StudentsRepository) {
        self.studentsRepository = studentsRepository
    }

    public func execute(password: String) -> Completable {
        studentsRepository.compareCurrentPasssword(password: password)
    }
}
