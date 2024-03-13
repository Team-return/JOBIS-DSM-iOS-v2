import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ConfirmPasswordFlow: Flow {
    public let container: Container
    private let rootViewController: ConfirmPasswordViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(ConfirmPasswordViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ConfirmPasswordStep else { return .none }

        switch step {
        case .confirmPasswordIsRequired:
            return navigateToConfirmPassword()

        case let .changePasswordIsRequired(currentPassword):
            return navigateToChangePassword(currentPassword: currentPassword)
        }
    }
}

private extension ConfirmPasswordFlow {
    func navigateToConfirmPassword() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToChangePassword(
        currentPassword: String
    ) -> FlowContributors {
        let changePasswordFlow = ChangePasswordFlow(container: container)

        Flows.use(changePasswordFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: changePasswordFlow,
            withNextStepper: OneStepper(
                withSingleStep: ChangePasswordStep.changePasswordIsRequired(currentPassword: currentPassword)
            )
        ))
    }
}
