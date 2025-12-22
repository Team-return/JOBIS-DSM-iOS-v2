import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class GenderSettingFlow: Flow {
    public let container: Container
    private let rootViewController: GenderSettingViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container, name: String, gcn: Int, email: String, password: String) {
        self.container = container
        let reactor = container.resolve(GenderSettingReactor.self, arguments: name, gcn, email, password)!
        self.rootViewController = GenderSettingViewController(reactor)
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GenderSettingStep else { return .none }

        switch step {
        case let .genderSettingIsRequired(name, gcn, email, password):
            return navigateToGenderSetting(
                name: name,
                gcn: gcn,
                email: email,
                password: password
            )

        case let .profileSettingIsRequired(name, gcn, email, password, isMan):
            return navigateToProfileSetting(
                name: name,
                gcn: gcn,
                email: email,
                password: password,
                isMan: isMan
            )

        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: PasswordSettingStep.tabsIsRequired)
        }
    }
}

private extension GenderSettingFlow {
    func navigateToGenderSetting(
        name: String,
        gcn: Int,
        email: String,
        password: String
    ) -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToProfileSetting(
        name: String,
        gcn: Int,
        email: String,
        password: String,
        isMan: Bool
    ) -> FlowContributors {
        let profileSettingFlow = ProfileSettingFlow(container: container, name: name, gcn: gcn, email: email, password: password, isMan: isMan)

        Flows.use(profileSettingFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: profileSettingFlow,
            withNextStepper: OneStepper(
                withSingleStep: ProfileSettingStep.profileSettingIsRequired(
                    name: name,
                    gcn: gcn,
                    email: email,
                    password: password,
                    isMan: isMan
                )
            )
        ))
    }
}
