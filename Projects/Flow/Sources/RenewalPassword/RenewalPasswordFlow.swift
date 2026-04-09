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

    public init(container: Container, email: String) {
        self.container = container
        let reactor = container.resolve(RenewalPasswordReactor.self, argument: email)!
        self.rootViewController = RenewalPasswordViewController(reactor)
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? RenewalPasswordStep else { return .none }

        switch step {
        case .renewalPasswordIsRequired:
            return navigateToRenewalPassword()

        case .tabsIsRequired:
            return navigateToTab()
        }
    }
}

private extension RenewalPasswordFlow {
    func navigateToRenewalPassword() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
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
