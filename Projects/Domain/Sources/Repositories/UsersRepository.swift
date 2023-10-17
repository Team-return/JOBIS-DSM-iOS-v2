import RxSwift

public protocol UsersRepository {
    func signin(req: SigninRequestQuery) -> Single<AuthorityType>
}
