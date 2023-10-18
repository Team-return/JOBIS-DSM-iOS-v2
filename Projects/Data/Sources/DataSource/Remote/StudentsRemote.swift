import Domain
import RxCocoa
import RxSwift

protocol StudentsRemote {
    func signup(req: SignupRequestQuery) -> Completable
    func renewalPassword(req: RenewalPasswordRequestQuery) -> Completable
    func studentExists(gcn: Int, name: String) -> Completable
    func fetchStudentInfo() -> Single<StudentInfoEntity>
    func changePassword(req: ChangePasswordRequestQuery) -> Completable
    func compareCurrentPasssword(password: String) -> Completable
    func changeProfileImage(url: String) -> Completable
}

final class StudentsRemoteImpl: BaseRemote<StudentsAPI>, StudentsRemote {
    func signup(req: SignupRequestQuery) -> Completable {
        request(.signup(req))
            .asCompletable()
    }

    func renewalPassword(req: RenewalPasswordRequestQuery) -> Completable {
        request(.renewalPassword(req))
            .asCompletable()
    }

    func studentExists(gcn: Int, name: String) -> Completable {
        request(.studentExists(gcn: gcn, name: name))
            .asCompletable()
    }

    func fetchStudentInfo() -> Single<StudentInfoEntity> {
        request(.fetchStudentInfo)
            .map(StudentInfoResponseDTO.self)
            .map { $0.toDomain() }
    }

    func changePassword(req: ChangePasswordRequestQuery) -> Completable {
        request(.changePassword(req))
            .asCompletable()
    }

    func compareCurrentPasssword(password: String) -> Completable {
        request(.compareCurrentPasssword(password: password))
            .asCompletable()
    }

    func changeProfileImage(url: String) -> Completable {
        request(.changeProfileImage(url: url))
            .asCompletable()
    }
}
