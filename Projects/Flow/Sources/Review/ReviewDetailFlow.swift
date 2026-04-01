import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ReviewDetailFlow: Flow {
    public let container: Container
    private var rootViewController: ReviewDetailViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ReviewDetailStep else { return .none }

        switch step {
        case let .reviewDetailIsRequired(reviewId):
            return navigateToReviewDetail(reviewId: reviewId)
        }
    }
}

private extension ReviewDetailFlow {
    func navigateToReviewDetail(reviewId: String) -> FlowContributors {
        rootViewController = container.resolve(ReviewDetailViewController.self, argument: reviewId)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }
}
