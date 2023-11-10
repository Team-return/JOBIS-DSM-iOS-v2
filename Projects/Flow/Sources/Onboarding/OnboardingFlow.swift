import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public class OnboardingFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
    }

    private let rootViewController = BaseNavigationController()

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? OnboardingStep else { return .none }

        switch step {
        case .onboardingIsRequired:
            return navigateToOnboarding()

        case .signinIsRequired:
            return navigateToSignin()

        case .signupIsRequired:
            return navigateToSignup()
        }
    }
}

private extension OnboardingFlow {
    func navigateToSignin() -> FlowContributors {
        let signinViewController = container.resolve(SigninViewController.self)!
        self.rootViewController.pushViewController(signinViewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: signinViewController,
            withNextStepper: signinViewController.viewModel
        ))
    }

    func navigateToSignup() -> FlowContributors {
        let signupViewController = container.resolve(SignupViewController.self)!
        self.rootViewController.pushViewController(signupViewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: signupViewController,
            withNextStepper: signupViewController.viewModel
        ))
    }

    func navigateToOnboarding() -> FlowContributors {
        let onboardingViewController = container.resolve(OnboardingViewController.self)!
        self.rootViewController.setViewControllers([onboardingViewController], animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: onboardingViewController,
            withNextStepper: onboardingViewController.viewModel
        ))
    }
}
