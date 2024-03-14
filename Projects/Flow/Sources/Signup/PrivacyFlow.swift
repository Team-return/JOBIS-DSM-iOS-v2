import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class PrivacyFlow: Flow {
    public let container: Container
    private let rootViewController: PrivacyViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(PrivacyViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PrivacyStep else { return .none }

        switch step {
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
            return .end(forwardToParentFlowWithStep: ProfileSettingStep.tabsIsRequired)
        }
    }
}

private extension PrivacyFlow {
    func navigateToPrivacy(
        name: String,
        gcn: Int,
        email: String,
        password: String,
        isMan: Bool,
        profileImageURL: String?
    ) -> FlowContributors {
        rootViewController.name = name
        rootViewController.gcn = gcn
        rootViewController.email = email
        rootViewController.password = password
        rootViewController.isMan = isMan
        rootViewController.profileImageURL = profileImageURL

        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
