import Foundation
import Swinject
import Core
import Domain

public final class PresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        AuthPresentationAssembly().assemble(container: container)
        MainPresentationAssembly().assemble(container: container)
        SettingPresentationAssembly().assemble(container: container)
    }
}
