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

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return .none }

        switch step {
        case .homeIsRequired:
            return navigateToHome()

        case .alarmIsRequired:
            return navigateToAlarm()
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

    func navigateToAlarm() -> FlowContributors {
        let alarmFlow = AlarmFlow(container: container)
        Flows.use(alarmFlow, when: .created) { root in
            self.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: alarmFlow,
            withNextStepper: OneStepper(withSingleStep: AlarmStep.alarmIsRequired)
        ))
    }
}
