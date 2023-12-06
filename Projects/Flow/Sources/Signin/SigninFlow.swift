import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class SigninFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
        self.rootViewController = SigninViewController(container.resolve(SigninViewModel.self)!)
    }

    private let rootViewController: SigninViewController

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SigninStep else { return .none }

        switch step {
        case .signinIsRequired:
            return navigateToSignin()
        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: OnboardingStep.tabsIsRequired)
        }
    }
}

private extension SigninFlow {
    func navigateToSignin() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
