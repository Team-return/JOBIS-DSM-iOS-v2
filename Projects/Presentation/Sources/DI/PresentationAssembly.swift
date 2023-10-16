import Foundation
import Swinject
import Core
import Domain

public final class PresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(MainViewModel.self) { resolver in
            MainViewModel(usecase: resolver.resolve(SendAuthCodeUseCase.self)!)
        }
        container.register(MainViewController.self) { resolver in
            MainViewController(resolver.resolve(MainViewModel.self)!)
        }
    }
}
