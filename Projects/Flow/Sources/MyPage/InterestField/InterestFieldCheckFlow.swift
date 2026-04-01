import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class InterestFieldCheckFlow: Flow {
    public let container: Container
    private var rootViewController: InterestFieldCheckViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? InterestFieldCheckStep else { return .none }

        switch step {
        case .interestFieldIsRequired:
            return navigateToInterestField()

        case .interestFieldCheckIsRequired:
            return navigateToInterestFieldCheck()

        case .popHomeFieldIsRequired:
            return popToMyPage()
        }
    }
}

private extension InterestFieldCheckFlow {
    func navigateToInterestField() -> FlowContributors {
        rootViewController = container.resolve(InterestFieldCheckViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToInterestFieldCheck() -> FlowContributors {
        let interestFieldCheckViewController = container.resolve(InterestFieldCheckViewController.self)!

        rootViewController.navigationController?.pushViewController(
            interestFieldCheckViewController,
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: interestFieldCheckViewController,
            withNextStepper: interestFieldCheckViewController.reactor
        ))
    }

    func popToMyPage() -> FlowContributors {
        rootViewController.navigationController?.popToRootViewController(animated: true)
        return .none
    }
}
