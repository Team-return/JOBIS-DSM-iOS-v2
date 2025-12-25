import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class InterestFieldFlow: Flow {
    public let container: Container
    private let rootViewController: InterestFieldViewController

    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(InterestFieldViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? InterestFieldStep else { return .none }

        switch step {
        case .interestFieldIsRequired:
            return navigateToInterestField()
        case .interestFieldCheckIsRequired:
            return navigateToInterestFieldCheck()
        }
    }
}

private extension InterestFieldFlow {
    func navigateToInterestField() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToInterestFieldCheck() -> FlowContributors {
        let interestFieldCheckViewController = container.resolve(InterestFieldCheckViewController.self)!
        rootViewController.navigationController?.pushViewController(interestFieldCheckViewController, animated: true)

        return .one(flowContributor: .contribute(
            withNextPresentable: interestFieldCheckViewController,
            withNextStepper: interestFieldCheckViewController.viewModel
        ))
    }
}
