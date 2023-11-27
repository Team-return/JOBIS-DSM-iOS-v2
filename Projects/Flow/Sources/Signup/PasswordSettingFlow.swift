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
        case .passwordSettingIsRequired:
            return navigateToPasswordSetting()
        case .privacyIsRequired:
            return .none
        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: VerifyEmailStep.tabsIsRequired)
        }
    }
}

private extension PasswordSettingFlow {
    func navigateToPasswordSetting() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

//    func navigateToPrivacy() -> FlowContributors {
//        let verifyEmailFlow = VerifyEmailFlow(container: container)
//        Flows.use(verifyEmailFlow, when: .created) { root in
//            self.rootViewController.navigationController?.pushViewController(root, animated: true)
//        }
//        return .one(flowContributor: .contribute(
//            withNextPresentable: verifyEmailFlow,
//            withNextStepper: OneStepper(withSingleStep: VerifyEmailStep.verifyEmailIsRequired)
//        ))
//    }
}
