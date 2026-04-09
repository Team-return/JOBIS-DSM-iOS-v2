import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class RejectReasonFlow: Flow {
    public let container: Container
    private let rootViewController: RejectReasonViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(
        container: Container,
        applicationID: Int,
        recruitmentID: Int,
        companyName: String,
        companyImageUrl: String
    ) {
        self.container = container
        self.rootViewController = container.resolve(
            RejectReasonViewController.self,
            arguments: applicationID, recruitmentID, companyName, companyImageUrl
        )!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? RejectReasonStep else { return .none }

        switch step {
        case .rejectReasonIsRequired:
            return navigateToRejectReason()
        case let .reApplyIsRequired(recruitmentID, applicationID, companyName, companyImageUrl):
            return navigateToReApply(recruitmentID, applicationID, companyName, companyImageUrl)
        }
    }
}

private extension RejectReasonFlow {
    func navigateToRejectReason() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToReApply(
        _ recruitmentID: Int,
        _ applicationID: Int,
        _ companyName: String,
        _ companyImageUrl: String
    ) -> FlowContributors {
        rootViewController.dismissBottomSheet()
        return .end(forwardToParentFlowWithStep: HomeStep.reApplyIsRequired(
            recruitmentID: recruitmentID,
            applicationID: applicationID,
            companyName: companyName,
            companyImageURL: companyImageUrl
        ))
    }
}
