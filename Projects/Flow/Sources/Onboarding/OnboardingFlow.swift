import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public class OnboardingFlow: Flow {
    public var container: Container

    public var window: UIWindow
    public var root: Presentable {
        return rootViewController
    }
    public init(window: UIWindow, container: Container) {
        self.window = window
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

        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: AppStep.tabsIsRequired)
        }
    }
}

private extension OnboardingFlow {
    func navigateToSignin() -> FlowContributors {
        let signinFlow = SigninFlow(window: window, container: container)
        Flows.use(signinFlow, when: .created) { root in
            self.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: signinFlow,
            withNextStepper: OneStepper(withSingleStep: SigninStep.signinIsRequired)
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
