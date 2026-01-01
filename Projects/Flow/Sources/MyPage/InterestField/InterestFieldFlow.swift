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
        if let step = step as? InterestFieldStep {
            switch step {
            case .interestFieldIsRequired:
                return navigateToInterestField()
            case .interestFieldCheckIsRequired:
                return navigateToInterestFieldCheck()
            }
        } else if let step = step as? InterestFieldCheckStep {
            switch step {
            case .popHomeFieldIsRequired:
                return popToMyPage()
            default:
                return .none
            }
        }

        return .none
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
            withNextStepper: interestFieldCheckViewController.reactor
        ))
    }

    func popToMyPage() -> FlowContributors {
        rootViewController.navigationController?.popToRootViewController(animated: true)
        return .none
    }
}
