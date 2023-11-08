import Foundation
import Swinject
import Core
import Domain

public final class PresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(MainViewModel.self) { resolver in
            MainViewModel(
                signinUseCase: resolver.resolve(SigninUseCase.self)!,
                reissueTokenUseCase: resolver.resolve(ReissueTokenUaseCase.self)!
            )
        }
        container.register(MainViewController.self) { resolver in
            MainViewController(resolver.resolve(MainViewModel.self)!)
        }

        container.register(OnboardingViewModel.self) { resolver in
            OnboardingViewModel()
        }
        container.register(OnboardingViewController.self) { resolver in
            OnboardingViewController(resolver.resolve(OnboardingViewModel.self)!)
        }

        container.register(SignupViewModel.self) { resolver in
            SignupViewModel()
        }
        container.register(SignupViewController.self) { resolver in
            SignupViewController(resolver.resolve(SignupViewModel.self)!)
        }

        container.register(SigninViewModel.self) { resolver in
            SigninViewModel()
        }
        container.register(SigninViewController.self) { resolver in
            SigninViewController(resolver.resolve(SigninViewModel.self)!)
        }
    }
}
