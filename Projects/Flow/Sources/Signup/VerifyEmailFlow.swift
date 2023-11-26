import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public class VerifyEmailFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(VerifyEmailViewController.self)!
    }

    private let rootViewController: VerifyEmailViewController

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? VerifyEmailStep else { return .none }

        switch step {
        case .verifyEmailIsRequired:
            return navigateToVerifyEmail()
        case .passwordIsRequired:
            return .none
        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: OnboardingStep.tabsIsRequired)
        }
    }
}

private extension VerifyEmailFlow {
    func navigateToVerifyEmail() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}