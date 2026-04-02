import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class AlarmFlow: Flow {
    public let container: Container
    private var rootViewController: AlarmViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AlarmStep else { return .none }

        switch step {
        case .alarmIsRequired:
            return navigateToAlarm()
        }
    }
}

private extension AlarmFlow {
    func navigateToAlarm() -> FlowContributors {
        rootViewController = container.resolve(AlarmViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }
}
