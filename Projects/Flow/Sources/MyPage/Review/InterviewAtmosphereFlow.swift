import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class InterviewAtmosphereFlow: Flow {
    public let container: Container
    private let rootViewController: InterviewAtmosphereViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(InterviewAtmosphereViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? InterviewAtmosphereStep else { return .none }

        switch step {
        case .interviewAtmosphereIsRequired:
            return navigateToInterviewAtmosphere()

        case .addQuestionIsRequired:
            return navigateToAddQuestion()

        case .navigateToWritableReview:
            return navigateToWritableReview()

        case .popViewController:
            return popViewController()

        case .popToWritableReview:
            return popToWritableReview()
        }
    }
}

private extension InterviewAtmosphereFlow {
    func navigateToInterviewAtmosphere() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToAddQuestion() -> FlowContributors {
        let addQuestionViewController = AddQuestionViewController(
            container.resolve(AddQuestionViewModel.self)!
        )
        
        rootViewController.navigationController?.pushViewController(
            addQuestionViewController,
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: addQuestionViewController,
            withNextStepper: addQuestionViewController.viewModel
        ))
    }

    func navigateToWritableReview() -> FlowContributors {
        let writableReviewFlow = WritableReviewFlow(container: container)
        Flows.use(writableReviewFlow, when: .created) { root in
            guard let viewController = root as? UIViewController else { return }
            self.rootViewController.navigationController?.pushViewController(
                viewController,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: writableReviewFlow,
            withNextStepper: OneStepper(
                withSingleStep: WritableReviewStep.writableReviewIsRequired
            )
        ))
    }

    func popViewController() -> FlowContributors {
        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }

    func popToWritableReview() -> FlowContributors {
        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
