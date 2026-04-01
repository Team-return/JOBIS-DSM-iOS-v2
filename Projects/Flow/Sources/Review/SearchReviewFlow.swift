import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class SearchReviewFlow: Flow {
    public let container: Container
    private var rootViewController: SearchReviewViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SearchReviewStep else { return .none }

        switch step {
        case .searchReviewIsRequired:
            return navigateToSearchReview()
        }
    }
}

private extension SearchReviewFlow {
    func navigateToSearchReview() -> FlowContributors {
        rootViewController = container.resolve(SearchReviewViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }
}
