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

        case .reviewFilterIsRequired:
            return navigateToReviewFilter()

        case .searchReviewIsRequired:
            return navigateToSearchReview()
        }
    }
}
private extension ReviewFlow {
    func navigateToReview() -> FlowContributors {
        let reviewViewController = container.resolve(ReviewViewController.self)!
        reviewViewController.viewWillappearWithTap = {
            reviewViewController.viewDidLoadPublisher.accept(())
        }

        self.rootViewController.setViewControllers(
            [reviewViewController],
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: reviewViewController,
            withNextStepper: reviewViewController.reactor
        ))
    }

    func navigateToReviewDetail(_ reviewID: String) -> FlowContributors {
        let reviewDetailFlow = ReviewDetailFlow(container: container)

        Flows.use(reviewDetailFlow, when: .created) { [weak self] (view: ReviewDetailViewController) in
            view.reactor.reviewID = reviewID
            view.isPopViewController = { [weak nav = self?.rootViewController] _ in
                let popView = nav?.topViewController as? ReviewViewController
                popView?.isTabNavigation = false
            }
            self?.rootViewController.pushViewController(view, animated: true)
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

    func navigateToReviewFilter() -> FlowContributors {
        let reviewFilterFlow = ReviewFilterFlow(container: container)

        Flows.use(reviewFilterFlow, when: .created) { (root) in
            self.rootViewController.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: reviewFilterFlow,
            withNextStepper: OneStepper(withSingleStep: ReviewFilterStep.reviewFilterIsRequired)
        ))
    }
}
