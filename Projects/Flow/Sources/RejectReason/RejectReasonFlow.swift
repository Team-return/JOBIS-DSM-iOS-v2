import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class RejectReasonFlow: Flow {
    public let container: Container
    private var rootViewController: RejectReasonViewController!
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? RejectReasonStep else { return .none }

        switch step {
        case let .rejectReasonIsRequired(applicationID, recruitmentID, companyName, companyImageUrl):
            return navigateToRejectReason(
                applicationID: applicationID,
                recruitmentID: recruitmentID,
                companyName: companyName,
                companyImageUrl: companyImageUrl
            )
        case let .reApplyIsRequired(recruitmentID, applicationID, companyName, companyImageUrl):
            return navigateToReApply(recruitmentID, applicationID, companyName, companyImageUrl)
        }
    }
}

private extension RejectReasonFlow {
    func navigateToRejectReason(
        applicationID: Int,
        recruitmentID: Int,
        companyName: String,
        companyImageUrl: String
    ) -> FlowContributors {
        let reactor = container.resolve(
            RejectReasonReactor.self,
            arguments: applicationID, recruitmentID, companyName, companyImageUrl
        )!
        rootViewController = RejectReasonViewController(reactor, state: .custom(height: 280))

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
