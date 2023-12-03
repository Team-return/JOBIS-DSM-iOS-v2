import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public class PasswordSettingFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(PasswordSettingViewController.self)!
    }

    private let rootViewController: PasswordSettingViewController

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PasswordSettingStep else { return .none }

        switch step {
        case let .passwordSettingIsRequired(name, gcn, email):
            return navigateToPasswordSetting(name: name, gcn: gcn, email: email)
        case let .privacyIsRequired(name, gcn, email, password):
            return navigateToPrivacy(name: name, gcn: gcn, email: email, password: password)
        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: VerifyEmailStep.tabsIsRequired)
        }
    }
}

private extension PasswordSettingFlow {
    func navigateToPasswordSetting(name: String, gcn: Int, email: String) -> FlowContributors {
        rootViewController.name = name
        rootViewController.gcn = gcn
        rootViewController.email = email
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToPrivacy(name: String, gcn: Int, email: String, password: String) -> FlowContributors {
        let privacyFlow = PrivacyFlow(container: container)
        Flows.use(privacyFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: privacyFlow,
            withNextStepper: OneStepper(
                withSingleStep: PrivacyStep.privacyIsRequired(
                    name: name,
                    gcn: gcn,
                    email: email,
                    password: password
                )
            )
        ))
    }
}
