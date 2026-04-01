import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ConfirmEmailFlow: Flow {
    public let container: Container
    private var rootViewController: ConfirmEmailViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ConfirmEmailStep else { return .none }

        switch step {
        case .confirmEmailIsRequired:
            return navigateToConfirmEmail()

        case let .renewalPasswordIsRequired(email):
            return navigateToRenewalPassword(email: email)
        }
    }
}

private extension ConfirmEmailFlow {
    func navigateToConfirmEmail() -> FlowContributors {
        rootViewController = container.resolve(ConfirmEmailViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToRenewalPassword(
        email: String
    ) -> FlowContributors {
        let renewalPasswordFlow = RenewalPasswordFlow(container: container)

        Flows.use(renewalPasswordFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: renewalPasswordFlow,
            withNextStepper: OneStepper(
                withSingleStep: RenewalPasswordStep.renewalPasswordIsRequired(email: email)
            )
        ))
    }
}
