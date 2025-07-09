import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class InterestFieldCheckFlow: Flow {
    public let container: Container
    private let rootViewController: InterestFieldCheckViewController

    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(InterestFieldCheckViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? InterestFieldCheckStep else { return .none }

        switch step {
        case .interestFieldIsRequired:
            return navigateToInterestField()

        case .interestFieldCheckIsRequired:
            return navigateToInterestFieldCheck()

        case .popHomeFieldIsRequired:
            return navigateToInterestField()
        }
    }
}

private extension InterestFieldCheckFlow {
    func navigateToInterestField() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
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
            withNextStepper: interestFieldCheckViewController.viewModel
        ))
    }

//    func navigateToHomeField() -> FlowContributors {
//        
//    }
}
