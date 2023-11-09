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

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainStep else { return .none }

        switch step {
        case .onboardingIsRequired:
            return navigateToOnboarding()
        }
    }
}

private extension MainFlow {
    func navigateToOnboarding() -> FlowContributors {
        let onboardingViewController = container.resolve(OnboardingViewController.self)!
        self.rootViewController.setViewControllers([onboardingViewController], animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: onboardingViewController,
            withNextStepper: onboardingViewController.viewModel
        ))
    }
}
