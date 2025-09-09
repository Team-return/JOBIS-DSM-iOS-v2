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

        case .navigateToInterviewAtmosphere:
            return navigateToInterviewAtmosphere()

        case .popToMyPage:
            return popToMyPage()
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
            view?.companyName = self.rootViewController.viewModel.companyName
            view?.dismiss = { (question: String, answer: String, techCode: CodeEntity, interviewFormat: InterviewFormat?, locationType: LocationType?) in
                self.rootViewController.viewModel.jobCode = techCode.code
                self.rootViewController.viewModel.interviewType = interviewFormat ?? .individual
                self.rootViewController.viewModel.location = locationType ?? .seoul
                self.rootViewController.viewModel.interviewReviewInfo.accept(
                    QnAEntity(
                        id: techCode.code,
                        question: question,
                        answer: answer
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

    func navigateToInterviewAtmosphere() -> FlowContributors {
        let interviewAtmosphereFlow = InterviewAtmosphereFlow(container: container)
        Flows.use(interviewAtmosphereFlow, when: .created) { root in
            guard let viewController = root as? UIViewController else { return }
            self.rootViewController.navigationController?.pushViewController(
                viewController,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: interviewAtmosphereFlow,
            withNextStepper: OneStepper(
                withSingleStep: InterviewAtmosphereStep.interviewAtmosphereIsRequired
            )
        ))
    }

    func popToMyPage() -> FlowContributors {
        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
