import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ProfileSettingFlow: Flow {
    public let container: Container
    private let rootViewController: ProfileSettingViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(ProfileSettingViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ProfileSettingStep else { return .none }

        switch step {
        case let .profileSettingIsRequired(name, gcn, email, password, isMan):
            return navigateToProfileSetting(
                name: name,
                gcn: gcn,
                email: email,
                password: password,
                isMan: isMan
            )

        case let .privacyIsRequired(name, gcn, email, password, isMan, profileImageURL):
            return navigateToPrivacy(
                name: name,
                gcn: gcn,
                email: email,
                password: password,
                isMan: isMan,
                profileImageURL: profileImageURL
            )

        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: GenderSettingStep.tabsIsRequired)
        }
    }
}

private extension ProfileSettingFlow {
    func navigateToProfileSetting(
        name: String,
        gcn: Int,
        email: String,
        password: String,
        isMan: Bool
    ) -> FlowContributors {
        rootViewController.name = name
        rootViewController.gcn = gcn
        rootViewController.email = email
        rootViewController.password = password
        rootViewController.isMan = isMan

        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToPrivacy(
        name: String,
        gcn: Int,
        email: String,
        password: String,
        isMan: Bool,
        profileImageURL: String?
    ) -> FlowContributors {
        let privacyFlow = PrivacyFlow(container: container)

        Flows.use(privacyFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: privacyFlow,
            withNextStepper: OneStepper(
                withSingleStep: PrivacyStep.privacyIsRequired(
                    name: name,
                    gcn: gcn,
                    email: email,
                    password: password,
                    isMan: isMan,
                    profileImageURL: profileImageURL
                )
            )
        ))
    }
}
