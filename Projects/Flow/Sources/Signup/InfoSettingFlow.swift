import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class InfoSettingFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(InfoSettingViewController.self)!
    }

    private let rootViewController: InfoSettingViewController

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? InfoSettingStep else { return .none }

        switch step {
        case .infoSettingIsRequired:
            return navigateToInfoSetting()
        case let .verifyEmailIsRequired(name, gcn):
            return navigateToVerifyEmail(name: name, gcn: gcn)
        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: OnboardingStep.tabsIsRequired)
        }
    }
}

private extension InfoSettingFlow {
    func navigateToInfoSetting() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToVerifyEmail(name: String, gcn: Int) -> FlowContributors {
        let verifyEmailFlow = VerifyEmailFlow(container: container)
        Flows.use(verifyEmailFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: verifyEmailFlow,
            withNextStepper: OneStepper(
                withSingleStep: VerifyEmailStep.verifyEmailIsRequired(
                    name: name,
                    gcn: gcn
                )
            )
        ))
    }
}
