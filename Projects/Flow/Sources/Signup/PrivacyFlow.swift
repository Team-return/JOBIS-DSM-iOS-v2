import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public class PrivacyFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(PrivacyViewController.self)!
    }

    private let rootViewController: PrivacyViewController

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PrivacyStep else { return .none }

        switch step {
        case .privacyIsRequired:
            return navigateToPrivacy()
        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: PasswordSettingStep.tabsIsRequired)
        }
    }
}

private extension PrivacyFlow {
    func navigateToPrivacy() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
