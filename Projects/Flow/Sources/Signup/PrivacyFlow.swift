import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class PrivacyFlow: Flow {
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
        case let .privacyIsRequired(name, gcn, email, password):
            return navigateToPrivacy(name: name, gcn: gcn, email: email, password: password)
        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: PasswordSettingStep.tabsIsRequired)
        }
    }
}

private extension PrivacyFlow {
    func navigateToPrivacy(name: String, gcn: Int, email: String, password: String) -> FlowContributors {
        rootViewController.name = name
        rootViewController.gcn = gcn
        rootViewController.email = email
        rootViewController.password = password
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
