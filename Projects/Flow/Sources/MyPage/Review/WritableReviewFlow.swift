import UIKit
import Presentation
import Swinject
import RxFlow
import Core
import Domain

public final class WritableReviewFlow: Flow {
    public let container: Container
    private let rootViewController: WritableReviewViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(WritableReviewViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? WritableReviewStep else { return .none }

        switch step {
        case .writableReviewIsRequired:
            return navigateToWritableReview()

        case .addReviewIsRequired:
            return navigateToAddReview()
        }
    }
}

private extension WritableReviewFlow {
    func navigateToWritableReview() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToAddReview() -> FlowContributors {
        let addReviewFlow = AddReviewFlow(container: container)
        Flows.use(addReviewFlow, when: .created) { root in
            let view = root as? AddReviewViewController
            view?.dismiss = { question, answer, techCode in
                self.rootViewController.viewModel.techCode = techCode.code
                self.rootViewController.viewModel.interviewReviewInfo.accept(
                    QnaEntity(
                        question: question,
                        answer: answer,
                        area: techCode.keyword
                    )
                )
            }
            self.rootViewController.present(
                root,
                animated: false
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: addReviewFlow,
            withNextStepper: OneStepper(
                withSingleStep: AddReviewStep.addReviewIsRequired
            )
        ))
    }
}
