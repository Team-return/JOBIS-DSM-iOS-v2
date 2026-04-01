import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ChangePasswordFlow: Flow {
    public let container: Container
    private var rootViewController: ChangePasswordViewController!
    public var root: Presentable {
        return rootViewController!
    }

    public init(container: Container) {
        self.container = container
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
        rootViewController = container.resolve(ChangePasswordViewController.self, argument: currentPassword)!

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
