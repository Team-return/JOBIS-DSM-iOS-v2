import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class WriteReviewFlow: Flow {
    public let container: Container
    private let rootViewController: WriteReviewViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(WriteReviewViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? WriteReviewStep else { return .none }

        switch step {
        case .writeReviewBottomSheetIsRequired:
            return .none

        case .writeReviewIsRequired:
            return navigateToWriteReview()
        }
    }
}

private extension WriteReviewFlow {
    func navigateToWriteReview() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
