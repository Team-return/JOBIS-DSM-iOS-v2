import RxSwift
import RxCocoa

public struct ChangeProfileImageUseCase {
    private let studentsRepository: any StudentsRepository

    public init(studentsRepository: any StudentsRepository) {
        self.studentsRepository = studentsRepository
    }

    public func execute(url: String) -> Completable {
        studentsRepository.changeProfileImage(url: url)
    }
}
