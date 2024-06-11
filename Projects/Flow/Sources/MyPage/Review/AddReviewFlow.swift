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

        case .techCodeIsRequired:
            return navigateToTechCode()
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

    func navigateToTechCode() -> FlowContributors {
        let techCodeFlow = TechCodeFlow(container: container)
        Flows.use(techCodeFlow, when: .created) { root in
            let view = root as? TechCodeViewController
//            self.rootViewController.dismiss(animated: true, completion: { modal에서 modal 넘어갈때 이전 modal 삭제하는 로직 구성해야함
//            })
//////=================================================
//            self.rootViewController.dismissBottomSheet()
            self.rootViewController.present(
                root,
                animated: false
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: techCodeFlow,
            withNextStepper: OneStepper(
                withSingleStep: TechCodeStep.techCodeIsRequired
            )
        ))
    }
}
