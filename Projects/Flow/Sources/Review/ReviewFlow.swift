import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ReviewFlow: Flow {
    public let container: Container
    private let rootViewController = BaseNavigationController()
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ReviewStep else { return .none }

        switch step {
        case .reviewIsRequired:
            return navigateToReview()

        case .reviewDetailIsRequired(let id):
            return navigateToReviewDetail(id)

        case .searchReviewIsRequired:
            return navigateToSearchReview()
        }
    }
}
private extension ReviewFlow {
    func navigateToReview() -> FlowContributors {
        let reviewViewController = container.resolve(ReviewViewController.self)!

        self.rootViewController.setViewControllers(
            [reviewViewController],
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: reviewViewController,
            withNextStepper: reviewViewController.viewModel
        ))
    }

    func navigateToReviewDetail(_ reviewID: Int) -> FlowContributors {
        let reviewDetailFlow = ReviewDetailFlow(container: container)

        Flows.use(reviewDetailFlow, when: .created) { (root) in
            let view = root as? ReviewDetailViewController
            view?.viewModel.reviewID = reviewID
            view?.isPopViewController = { id in
                let popView = self.rootViewController.topViewController as? ReviewViewController
                popView?.isTabNavigation = false
            }
            self.rootViewController.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: reviewDetailFlow,
            withNextStepper: OneStepper(withSingleStep: ReviewDetailStep.reviewDetailIsRequired)
        ))
    }

    func navigateToSearchReview() -> FlowContributors {
        let searchReviewFlow = SearchReviewFlow(container: container)

        Flows.use(searchReviewFlow, when: .created) { (root) in
            let view = root as? SearchReviewViewController
            self.rootViewController.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: searchReviewFlow,
            withNextStepper: OneStepper(withSingleStep: SearchReviewStep.searchReviewIsRequired)
        ))
    }
}
