import RxSwift
import Domain

final class StudentsRepositoryImpl: StudentsRepository {
    private let remoteStudentsDataSource: any RemoteStudentsDataSource

    init(remoteStudentsDataSource: any RemoteStudentsDataSource) {
        self.remoteStudentsDataSource = remoteStudentsDataSource
    }

    func signup(req: SignupRequestQuery) -> Completable {
        remoteStudentsDataSource.signup(req: req)
    }

    func renewalPassword(req: RenewalPasswordRequestQuery) -> Completable {
        remoteStudentsDataSource.renewalPassword(req: req)
    }

    func studentExists(gcn: String, name: String) -> Completable {
        remoteStudentsDataSource.studentExists(gcn: gcn, name: name)
    }

    func fetchStudentInfo() -> Single<StudentInfoEntity> {
        remoteStudentsDataSource.fetchStudentInfo()
    }

    func compareCurrentPasssword(password: String) -> Completable {
        remoteStudentsDataSource.compareCurrentPasssword(password: password)
    }

    func changePassword(req: ChangePasswordRequestQuery) -> Completable {
        remoteStudentsDataSource.changePassword(req: req)
    }

    func changeProfileImage(url: String) -> Completable {
        remoteStudentsDataSource.changeProfileImage(url: url)
    }
}
