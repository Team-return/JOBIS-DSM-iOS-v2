import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class InterviewReviewDetailFlow: Flow {
    public let container: Container
    private var rootViewController: InterviewReviewDetailViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? InterviewReviewDetailStep else { return .none }

        switch step {
        case let .interviewReviewDetailIsRequired(reviewId):
            return navigateToInterviewReviewDetail(reviewId: reviewId)
        }
    }
}

private extension InterviewReviewDetailFlow {
    func navigateToInterviewReviewDetail(reviewId: String) -> FlowContributors {
        rootViewController = container.resolve(
            InterviewReviewDetailViewController.self,
            argument: reviewId
        )!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }
}
