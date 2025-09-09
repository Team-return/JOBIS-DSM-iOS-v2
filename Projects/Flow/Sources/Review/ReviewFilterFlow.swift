import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ReviewFilterFlow: Flow {
    public let container: Container
    private let rootViewController: ReviewFilterViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(ReviewFilterViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ReviewFilterStep else { return .none }

        switch step {
        case .reviewFilterIsRequired:
            return navigateToReviewFilter()

        case let .popToReview(jobCode):
            return popToReview(jobCode: jobCode ?? "")
        }
    }
}

private extension ReviewFilterFlow {
    func navigateToReviewFilter() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func popToReview(jobCode: String) -> FlowContributors {
        let reviewPopView = self.rootViewController.navigationController?.viewControllers.first as? ReviewViewController

        reviewPopView?.viewModel.jobCode = jobCode

        self.rootViewController.navigationController?.popViewController(animated: true)

        return .none
    }
}
