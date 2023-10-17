import RxSwift
import Domain

final class StudentsRepositoryImpl: StudentsRepository {
    private let studentsRemote: any StudentsRemote

    init(studentsRemote: any StudentsRemote) {
        self.studentsRemote = studentsRemote
    }

    func signup(req: SignupRequestQuery) -> Completable {
        studentsRemote.signup(req: req)
    }

    func renewalPassword(req: RenewalPasswordRequestQuery) -> Completable {
        studentsRemote.renewalPassword(req: req)
    }

    func studentExists(gcn: Int, name: String) -> Completable {
        studentsRemote.studentExists(gcn: gcn, name: name)
    }

    func fetchStudentInfo() -> Single<StudentInfoEntity> {
        studentsRemote.fetchStudentInfo()
    }

    func compareCurrentPasssword(password: String) -> Completable {
        studentsRemote.compareCurrentPasssword(password: password)
    }

    func changePassword(req: ChangePasswordRequestQuery) -> Completable {
        studentsRemote.changePassword(req: req)
    }

    func changeProfileImage(url: String) -> Completable {
        studentsRemote.changeProfileImage(url: url)
    }
}
