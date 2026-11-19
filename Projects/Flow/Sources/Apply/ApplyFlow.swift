import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ApplyFlow: Flow {
    public let container: Container
    private let rootViewController: ApplyViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(
        container: Container,
        recruitmentId: Int? = nil,
        applicationId: Int? = nil,
        companyName: String,
        companyImageURL: String,
        applyType: ApplyType
    ) {
        self.container = container
        self.rootViewController = container.resolve(
            ApplyViewController.self,
            arguments: recruitmentId, applicationId, companyName, companyImageURL, applyType
        )!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ApplyStep else { return .none }

        switch step {
        case .applyIsRequired:
            return navigateToApply()

        case .homeIsRequired:
            return navigateToHome()

        case let .reApplyIsRequired(id, name, imageURL):
            return navigateToReApply(id: id, name: name, imageURL: imageURL)

        case let .errorToast(message):
            return errorToast(message: message)
        }
    }
}

private extension ApplyFlow {
    func navigateToApply() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToReApply(id: Int, name: String, imageURL: String) -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToHome() -> FlowContributors {
        let navigationController = rootViewController.navigationController
        let tabBarController = rootViewController.tabBarController

        navigationController?.popToRootViewController(animated: false)
        tabBarController?.selectedIndex = 0
        return .none
    }

    func errorToast(message: String) -> FlowContributors {
        self.rootViewController.showJobisToast(text: message, inset: 92)
        return .none
    }
}
