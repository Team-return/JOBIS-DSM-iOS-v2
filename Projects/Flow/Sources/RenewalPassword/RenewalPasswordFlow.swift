import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class RenewalPasswordFlow: Flow {
    public let container: Container
    private var rootViewController: RenewalPasswordViewController!
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
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
        let reactor = container.resolve(RenewalPasswordReactor.self, argument: email)!
        rootViewController = RenewalPasswordViewController(reactor)

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
