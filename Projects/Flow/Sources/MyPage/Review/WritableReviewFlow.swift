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

        case .reviewCompleteIsRequired:
            return navigateToReviewComplete()

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
            view?.dismiss = { (techCode: CodeEntity, interviewFormat: InterviewFormat?, locationType: LocationType?) in

                self.rootViewController.viewModel.jobCode = techCode.code
                self.rootViewController.viewModel.interviewType = interviewFormat ?? .individual
                self.rootViewController.viewModel.location = locationType ?? .seoul
                view?.dismissBottomSheet()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.rootViewController.viewModel.steps.accept(WritableReviewStep.navigateToInterviewAtmosphere)
                }
            }
            self.rootViewController.present(root, animated: false)
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: addReviewFlow,
            withNextStepper: OneStepper(
                withSingleStep: AddReviewStep.addReviewIsRequired
            )
        ))
    }

    func navigateToInterviewAtmosphere() -> FlowContributors {
        let interviewAtmosphereFlow = InterviewAtmosphereFlow(
            container: container,
            companyID: rootViewController.viewModel.companyID,
            interviewType: rootViewController.viewModel.interviewType,
            location: rootViewController.viewModel.location,
            jobCode: rootViewController.viewModel.jobCode,
            interviewerCount: rootViewController.viewModel.interviewerCount
        )
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

    func popToMyPage() -> FlowContributors {
        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
