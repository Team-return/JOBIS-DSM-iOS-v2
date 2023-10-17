import Foundation
import Swinject
import Core
import Domain

public final class DataSourceAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(AuthRemote.self) { resolver in
            AuthRemoteImpl(keychainLocal: resolver.resolve(Keychain.self)!)
        }
    }
}
