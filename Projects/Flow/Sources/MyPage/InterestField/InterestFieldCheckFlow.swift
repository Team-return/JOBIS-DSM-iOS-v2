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
        guard let step = step as? InterestFieldStep else { return .none }

        switch step {
        case .interestFieldCheckIsRequired:
            return navigateToInterestFieldCheck()
        default:
            return .none
        }
    }
}

private extension InterestFieldCheckFlow {
    func navigateToInterestFieldCheck() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
