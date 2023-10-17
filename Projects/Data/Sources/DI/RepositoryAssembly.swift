import Foundation
import Swinject
import Domain

public final class RepositoryAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(AuthRepository.self) { resolver in
            AuthRepositoryImpl(authRemote: resolver.resolve(AuthRemote.self)!)
        }

        container.register(UsersRepository.self) { resolver in
            UsersRepositoryImpl(usersRemote: resolver.resolve(UsersRemote.self)!)
        }
    }
}
