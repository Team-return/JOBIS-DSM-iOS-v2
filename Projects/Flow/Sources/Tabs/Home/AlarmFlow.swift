import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class AlarmFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(AlarmViewController.self)!
    }

    private let rootViewController: AlarmViewController

    public func navigate(to step: Step) -> RxFlow.FlowContributors {
        guard let step = step as? AlarmStep else { return .none }

        switch step {
        case .alarmIsRequired:
            return navigateToAlarm()
        }
    }
}

private extension AlarmFlow {
    func navigateToAlarm() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
