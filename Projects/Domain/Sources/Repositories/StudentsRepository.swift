import RxCocoa
import RxSwift
import Foundation

public protocol StudentsRepository {
    func signup(req: SignupRequestQuery) -> Completable
    func renewalPassword(req: RenewalPasswordRequestQuery) -> Completable
    func studentExists(gcn: String, name: String) -> Completable
    func fetchStudentInfo() -> Single<StudentInfoEntity>
    func compareCurrentPasssword(password: String) -> Completable
    func changePassword(req: ChangePasswordRequestQuery) -> Completable
    func changeProfileImage(url: String) -> Completable
}
