import RxSwift

public struct LogoutUseCase {
    public init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }

    private let usersRepository: UsersRepository

    public func execute() {
        usersRepository.logout()
    }
}
