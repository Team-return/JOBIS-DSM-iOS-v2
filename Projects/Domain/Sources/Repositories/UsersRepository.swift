import RxSwift

public protocol UsersRepository {
    func signin(req: SigninRequestQuery) -> Single<AuthorityType>
    func logout()
    func deleteDeviceToken() -> Completable
}
