import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class NotificationSettingFlow: Flow {
    public let container: Container
    private var rootViewController: NotificationSettingViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? NotificationSettingStep else { return .none }

        switch step {
        case .notificationSettingIsRequired:
            return navigateToNotificationSetting()
        }
    }
}

private extension NotificationSettingFlow {
    func navigateToNotificationSetting() -> FlowContributors {
        rootViewController = container.resolve(NotificationSettingViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }
}
