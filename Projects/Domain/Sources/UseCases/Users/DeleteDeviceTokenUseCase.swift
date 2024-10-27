import RxSwift

public struct DeleteDeviceTokenUseCase {
    public init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }

    private let usersRepository: UsersRepository

    public func execute() {
        usersRepository.deleteDeviceToken()
    }
}
