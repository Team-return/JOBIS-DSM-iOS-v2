import UIKit
import Presentation
import Swinject
import RxFlow
import Core
import Domain

public final class InterviewAtmosphereFlow: Flow {
    public let container: Container
    private let rootViewController: InterviewAtmosphereViewController
    public var root: Presentable {
        return rootViewController
    }

    private let companyID: Int
    private let interviewType: InterviewFormat
    private let location: LocationType
    private let jobCode: Int
    private let interviewerCount: Int

    public init(
        container: Container,
        companyID: Int,
        interviewType: InterviewFormat,
        location: LocationType,
        jobCode: Int,
        interviewerCount: Int
    ) {
        self.container = container
        self.rootViewController = container.resolve(InterviewAtmosphereViewController.self)!
        self.companyID = companyID
        self.interviewType = interviewType
        self.location = location
        self.jobCode = jobCode
        self.interviewerCount = interviewerCount
    }

    public func navigate(to step: Step) -> FlowContributors {
        if let writableReviewStep = step as? WritableReviewStep {
            switch writableReviewStep {
            case .reviewCompleteIsRequired:
                return navigateToReviewComplete()
            default:
                return .none
            }
        }

        guard let step = step as? InterviewAtmosphereStep else { return .none }

        switch step {
        case .interviewAtmosphereIsRequired:
            return navigateToInterviewAtmosphere()

        case let .addQuestionIsRequired(qnas):
            return navigateToAddQuestion(qnas: qnas as? [QnaRequestQuery] ?? [])

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

    func navigateToAddQuestion(qnas: [QnaRequestQuery]) -> FlowContributors {
        let viewModel = AddQuestionViewModel(
            postReviewUseCase: container.resolve(PostReviewUseCase.self)!,
            companyID: companyID,
            interviewType: interviewType,
            location: location,
            jobCode: jobCode,
            interviewerCount: interviewerCount,
            qnas: qnas
        )
        let addQuestionViewController = AddQuestionViewController(viewModel)

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

    func navigateToReviewComplete() -> FlowContributors {
        let reviewCompleteViewController = container.resolve(ReviewCompleteViewController.self)!

        rootViewController.navigationController?.pushViewController(
            reviewCompleteViewController,
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: reviewCompleteViewController,
            withNextStepper: reviewCompleteViewController.viewModel
        ))
    }
}
