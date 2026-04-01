import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ChangePasswordFlow: Flow {
    public let container: Container
    private let rootViewController: ChangePasswordViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container, currentPassword: String = "") {
        self.container = container
        self.rootViewController = container.resolve(
            ChangePasswordViewController.self,
            argument: currentPassword
        )!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ChangePasswordStep else { return .none }

        switch step {
        case let .changePasswordIsRequired(currentPassword):
            return navigateToChangePassword(currentPassword: currentPassword)

        case .tabsIsRequired:
            return navigateToTab()
        }
    }
}

private extension ChangePasswordFlow {
    func navigateToChangePassword(currentPassword: String) -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToTab() -> FlowContributors {
        self.rootViewController.navigationController?.popToRootViewController(animated: true)
        return .none
    }
}
