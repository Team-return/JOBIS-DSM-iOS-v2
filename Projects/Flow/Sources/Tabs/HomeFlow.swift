import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class HomeFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
    }

    private let rootViewController = BaseNavigationController()

    public func navigate(to step: Step) -> RxFlow.FlowContributors {
        guard let step = step as? HomeStep else { return .none }

        switch step {
        case .homeIsRequired:
            return navigateToHome()
        }
    }
}

private extension HomeFlow {
    func navigateToHome() -> FlowContributors {
        let homeViewController = container.resolve(HomeViewController.self)!
        self.rootViewController.setViewControllers([homeViewController], animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: homeViewController,
            withNextStepper: homeViewController.viewModel
        ))
    }
}
