import Domain
import RxCocoa
import RxSwift

protocol RemoteStudentsDataSource {
    func signup(req: SignupRequestQuery) -> Completable
    func renewalPassword(req: RenewalPasswordRequestQuery) -> Completable
    func studentExists(gcn: String, name: String) -> Completable
    func fetchStudentInfo() -> Single<StudentInfoEntity>
    func changePassword(req: ChangePasswordRequestQuery) -> Completable
    func compareCurrentPassword(password: String) -> Completable
    func changeProfileImage(url: String) -> Completable
}

final class RemoteStudentsDataSourceImpl: RemoteBaseDataSource<StudentsAPI>, RemoteStudentsDataSource {
    func signup(req: SignupRequestQuery) -> Completable {
        request(.signup(req))
            .asCompletable()
    }

    func renewalPassword(req: RenewalPasswordRequestQuery) -> Completable {
        request(.renewalPassword(req))
            .asCompletable()
    }

    func studentExists(gcn: String, name: String) -> Completable {
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

    func compareCurrentPassword(password: String) -> Completable {
        request(.compareCurrentPassword(password: password))
            .asCompletable()
    }

    func changeProfileImage(url: String) -> Completable {
        request(.changeProfileImage(url: url))
            .asCompletable()
    }
}
