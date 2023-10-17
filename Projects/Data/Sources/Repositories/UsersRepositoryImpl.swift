import RxSwift
import Domain

final class UsersRepositoryImpl: UsersRepository {
    private let usersRemote: any UsersRemote

    init(usersRemote: any UsersRemote) {
        self.usersRemote = usersRemote
    }

    func signin(req: SigninRequestQuery) -> Single<AuthorityType> {
        usersRemote.signin(req: req)
    }
}
