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

    private var reactor: PrivacyReactor?

    public init(container: Container) {
        self.container = container
        self.rootViewController = PrivacyViewController()
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
        let reactor = container.resolve(PrivacyReactor.self, arguments: name, gcn, email, password, isMan, profileImageURL)!
        self.reactor = reactor
        rootViewController.reactor = reactor

        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: reactor
        ))
    }
}
