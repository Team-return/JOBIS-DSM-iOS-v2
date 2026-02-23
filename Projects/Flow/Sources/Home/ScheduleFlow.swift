import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ScheduleFlow: Flow {
    public let container: Container
    private let rootViewController: ScheduleManagementViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(ScheduleManagementViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ScheduleStep else { return .none }

        switch step {
        case .scheduleIsRequired:
            return navigateToSchedule()
        case .addScheduleIsRequired:
            return navigateToAddSchedule()
        }
    }
}

private extension ScheduleFlow {
    func navigateToSchedule() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToAddSchedule() -> FlowContributors {
        let addScheduleViewController = container.resolve(AddScheduleViewController.self)!
        rootViewController.navigationController?.pushViewController(addScheduleViewController, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: addScheduleViewController,
            withNextStepper: addScheduleViewController.reactor
        ))
    }
}
