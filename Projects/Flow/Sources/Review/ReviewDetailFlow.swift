import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ReviewDetailFlow: Flow {
    public let container: Container
    private let rootViewController: ReviewDetailViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container, reviewId: String) {
        self.container = container
        self.rootViewController = container.resolve(ReviewDetailViewController.self, argument: reviewId)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ReviewDetailStep else { return .none }

        switch step {
        case .reviewDetailIsRequired:
            return navigateToReviewDetail()
        }
    }
}

private extension ReviewDetailFlow {
    func navigateToReviewDetail() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }
}
