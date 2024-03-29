import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class PasswordSettingFlow: Flow {
    public let container: Container
    private let rootViewController: PasswordSettingViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(PasswordSettingViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PasswordSettingStep else { return .none }

        switch step {
        case let .passwordSettingIsRequired(name, gcn, email):
            return navigateToPasswordSetting(name: name, gcn: gcn, email: email)

        case let .genderSettingIsRequired(name, gcn, email, password):
            return navigateToGenderSetting(name: name, gcn: gcn, email: email, password: password)

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

    func navigateToGenderSetting(
        name: String,
        gcn: Int,
        email: String,
        password: String
    ) -> FlowContributors {
        let genderFlow = GenderSettingFlow(container: container)

        Flows.use(genderFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: genderFlow,
            withNextStepper: OneStepper(
                withSingleStep: GenderSettingStep.genderSettingIsRequired(
                    name: name,
                    gcn: gcn,
                    email: email,
                    password: password
                )
            )
        ))
    }
}
