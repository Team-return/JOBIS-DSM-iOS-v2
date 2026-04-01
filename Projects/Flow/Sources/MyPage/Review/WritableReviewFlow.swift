import UIKit
import Presentation
import Swinject
import RxFlow
import Core
import Domain

public final class WritableReviewFlow: Flow {
    public let container: Container
    private var rootViewController: WritableReviewViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
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
        rootViewController = container.resolve(WritableReviewViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToAddReview() -> FlowContributors {
        let addReviewFlow = AddReviewFlow(container: container)

        Flows.use(addReviewFlow, when: .created) { root in
            let view = root as? AddReviewViewController
            view?.companyName = self.rootViewController.reactor.companyName
            view?.dismiss = { (techCode: CodeEntity, interviewFormat: InterviewFormat?, locationType: LocationType?) in

                self.rootViewController.reactor.jobCode = techCode.code
                self.rootViewController.reactor.interviewType = interviewFormat ?? .individual
                self.rootViewController.reactor.location = locationType ?? .seoul
                view?.dismissBottomSheet()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.rootViewController.reactor.steps.accept(WritableReviewStep.navigateToInterviewAtmosphere)
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
                withSingleStep: InterviewAtmosphereStep.interviewAtmosphereIsRequired(
                    companyID: rootViewController.viewModel.companyID,
                    interviewType: rootViewController.viewModel.interviewType.rawValue,
                    location: rootViewController.viewModel.location.rawValue,
                    jobCode: rootViewController.viewModel.jobCode,
                    interviewerCount: rootViewController.viewModel.interviewerCount
                )
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
        guard let navigationController = self.rootViewController.navigationController else {
            return .none
        }

        let viewControllers = navigationController.viewControllers
        if let rootIndex = viewControllers.firstIndex(of: rootViewController), rootIndex > 0 {
            navigationController.popToViewController(viewControllers[rootIndex - 1], animated: true)
        }

        return .none
    }
}
