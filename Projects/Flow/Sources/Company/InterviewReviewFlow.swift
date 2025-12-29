import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class InterviewReviewDetailFlow: Flow {
    public let container: Container
    private let rootViewController: InterviewReviewDetailViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container, reviewId: String) {
        self.container = container
        self.rootViewController = container.resolve(InterviewReviewDetailViewController.self, argument: reviewId)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? InterviewReviewDetailStep else { return .none }

        switch step {
        case .interviewReviewDetailIsRequired:
            return navigateToInterviewReviewDetail()
        }
    }
}

private extension InterviewReviewDetailFlow {
    func navigateToInterviewReviewDetail() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }
}
