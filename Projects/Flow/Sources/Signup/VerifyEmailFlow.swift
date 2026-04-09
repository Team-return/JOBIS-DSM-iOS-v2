import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class VerifyEmailFlow: Flow {
    public let container: Container
    private let rootViewController: VerifyEmailViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container, name: String, gcn: Int) {
        self.container = container
        let reactor = container.resolve(VerifyEmailReactor.self, arguments: name, gcn)!
        self.rootViewController = VerifyEmailViewController(reactor)
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? VerifyEmailStep else { return .none }

        switch step {
        case let .verifyEmailIsRequired(name, gcn):
            return navigateToVerifyEmail(name: name, gcn: gcn)

        case let .passwordSettingIsRequired(name, gcn, email):
            return navigateToPasswordSetting(name: name, gcn: gcn, email: email)

        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: InfoSettingStep.tabsIsRequired)
        }
    }
}

private extension VerifyEmailFlow {
    func navigateToVerifyEmail(name: String, gcn: Int) -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToPasswordSetting(name: String, gcn: Int, email: String) -> FlowContributors {
        let passwordSettingFlow = PasswordSettingFlow(container: container, name: name, gcn: gcn, email: email)

        Flows.use(passwordSettingFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: passwordSettingFlow,
            withNextStepper: OneStepper(
                withSingleStep: PasswordSettingStep.passwordSettingIsRequired(
                    name: name,
                    gcn: gcn,
                    email: email
                )
            )
        ))
    }
}
