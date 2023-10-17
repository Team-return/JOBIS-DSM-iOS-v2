import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public class MainFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
    }

    private let rootViewController = UINavigationController()

    public func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? MainStep else { return .none }

        switch step {
        case .loginIsRequired:
            return navigateToLoginScreen()
        }
    }
}

private extension MainFlow {
    func navigateToLoginScreen() -> FlowContributors {
        let mainViewController = container.resolve(MainViewController.self)!
        self.rootViewController.setViewControllers([mainViewController], animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: mainViewController,
            withNextStepper: mainViewController.viewModel
        ))
    }
}
