import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class RenewalPasswordFlow: Flow {
    public let container: Container
    private let rootViewController: RenewalPasswordViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(RenewalPasswordViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? RenewalPasswordStep else { return .none }

        switch step {
        case let .renewalPasswordIsRequired(email):
            return navigateToRenewalPassword(email: email)

        case .tabsIsRequired:
            return navigateToTab()
        }
    }
}

private extension RenewalPasswordFlow {
    func navigateToRenewalPassword(email: String) -> FlowContributors {
        rootViewController.email = email

        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToTab() -> FlowContributors {
        if let view = rootViewController.navigationController?.viewControllers[1] {
            self.rootViewController.navigationController?.popToViewController(
                view,
                animated: true
            )
        }
        return .none
    }
}
