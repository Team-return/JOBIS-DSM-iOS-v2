import RxSwift

public struct SigninUseCase {
    public init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }

    private let usersRepository: UsersRepository

    public func execute(req: SigninRequestQuery) -> Single<AuthorityType> {
        usersRepository.signin(req: req)
    }
}
