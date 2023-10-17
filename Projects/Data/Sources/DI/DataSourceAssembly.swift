import Foundation
import Swinject
import Core
import Domain

public final class DataSourceAssembly: Assembly {
    public init() {}

    private let keychain = { (resolver: Resolver) in
        resolver.resolve(Keychain.self)!
    }

    public func assemble(container: Container) {
        container.register(AuthRemote.self) { resolver in
            AuthRemoteImpl(keychainLocal: self.keychain(resolver))
        }

        container.register(UsersRemote.self) { resolver in
            UsersRemoteImpl(keychainLocal: self.keychain(resolver))
        }
    }
}
