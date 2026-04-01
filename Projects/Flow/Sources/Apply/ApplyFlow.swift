import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ApplyFlow: Flow {
    public let container: Container
    private var rootViewController: ApplyViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ApplyStep else { return .none }

        switch step {
        case let .applyIsRequired(recruitmentId, name, imageURL):
            return navigateToApply(
                recruitmentId: recruitmentId,
                applicationId: nil,
                name: name,
                imageURL: imageURL,
                applyType: .apply
            )

        case let .reApplyIsRequired(applicationId, name, imageURL):
            return navigateToApply(
                recruitmentId: nil,
                applicationId: applicationId,
                name: name,
                imageURL: imageURL,
                applyType: .reApply
            )

        case .popToRecruitmentDetail:
            return popToRecruitmentDetail()

        case let .errorToast(message):
            return errorToast(message: message)
        }
    }
}

private extension ApplyFlow {
    func navigateToApply(
        recruitmentId: Int?,
        applicationId: Int?,
        name: String,
        imageURL: String,
        applyType: ApplyType
    ) -> FlowContributors {
        rootViewController = container.resolve(
            ApplyViewController.self,
            arguments: recruitmentId, applicationId, name, imageURL, applyType
        )!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func popToRecruitmentDetail() -> FlowContributors {
        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }

    func errorToast(message: String) -> FlowContributors {
        self.rootViewController.showJobisToast(text: message, inset: 92)
        return .none
    }
}
