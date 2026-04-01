import UIKit
import Presentation
import Swinject
import RxFlow
import Core
import Domain

public final class InterviewAtmosphereFlow: Flow {
    public let container: Container
    private var rootViewController: InterviewAtmosphereViewController!
    public var root: Presentable { rootViewController! }

    private var companyID: Int = 0
    private var interviewType: InterviewFormat = .individual
    private var location: LocationType = .seoul
    private var jobCode: Int = 0
    private var interviewerCount: Int = 0

    public init(container: Container) {
        self.container = container
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
        case let .interviewAtmosphereIsRequired(companyID, interviewType, location, jobCode, interviewerCount):
            return navigateToInterviewAtmosphere(
                companyID: companyID,
                interviewType: interviewType,
                location: location,
                jobCode: jobCode,
                interviewerCount: interviewerCount
            )

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
    func navigateToInterviewAtmosphere(
        companyID: Int,
        interviewType: InterviewFormat,
        location: LocationType,
        jobCode: Int,
        interviewerCount: Int
    ) -> FlowContributors {
        self.companyID = companyID
        self.interviewType = interviewType
        self.location = location
        self.jobCode = jobCode
        self.interviewerCount = interviewerCount
        rootViewController = container.resolve(InterviewAtmosphereViewController.self)!
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
