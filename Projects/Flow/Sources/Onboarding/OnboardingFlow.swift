import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class OnboardingFlow: Flow {
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

        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: AppStep.tabsIsRequired)
        }
    }
}

private extension OnboardingFlow {
    func navigateToSignin() -> FlowContributors {
        let signinFlow = SigninFlow(container: container)
        Flows.use(signinFlow, when: .created) { root in
            self.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: signinFlow,
            withNextStepper: OneStepper(withSingleStep: SigninStep.signinIsRequired)
        ))
    }

    func navigateToSignup() -> FlowContributors {
        let signupFlow = InfoSettingFlow(container: container)
        Flows.use(signupFlow, when: .created) { root in
            self.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: signupFlow,
            withNextStepper: OneStepper(withSingleStep: InfoSettingStep.infoSettingIsRequired)
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
