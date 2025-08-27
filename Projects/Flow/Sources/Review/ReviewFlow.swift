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
