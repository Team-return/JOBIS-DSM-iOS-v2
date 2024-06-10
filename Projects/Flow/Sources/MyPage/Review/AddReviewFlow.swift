import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class AddReviewFlow: Flow {
    public let container: Container
    private let rootViewController: AddReviewViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = AddReviewViewController(
            container.resolve(AddReviewViewModel.self)!,
            state: .custom(height: 500)
        )
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AddReviewStep else { return .none }

        switch step {
        case .addReviewIsRequired:
            return navigateToAddReview()
        }
    }
}

private extension AddReviewFlow {
    func navigateToAddReview() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
