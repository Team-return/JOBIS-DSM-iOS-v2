import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class SigninFlow: Flow {
    public let container: Container
    private let rootViewController: SigninViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = SigninViewController(container.resolve(SigninReactor.self)!)
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SigninStep else { return .none }

        switch step {
        case .signinIsRequired:
            return navigateToSignin()

        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: OnboardingStep.tabsIsRequired)

        case .confirmEmailIsRequired:
            return navigateToConfirmEmail()
        }
    }
}

private extension SigninFlow {
    func navigateToSignin() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToConfirmEmail() -> FlowContributors {
        let confirmEmailFlow = ConfirmEmailFlow(container: container)

        Flows.use(confirmEmailFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: confirmEmailFlow,
            withNextStepper: OneStepper(
                withSingleStep: ConfirmEmailStep.confirmEmailIsRequired
            )
        ))
    }
}
