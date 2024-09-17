import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class NotificationSettingFlow: Flow {
    public let container: Container
    private let rootViewController: NotificationSettingViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(NotificationSettingViewController.self)!
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
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
