import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class TechCodeFlow: Flow {
    public let container: Container
    private let rootViewController: TechCodeViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = TechCodeViewController(
            container.resolve(TechCodeViewModel.self)!,
            state: .custom(height: 500)
        )
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TechCodeStep else { return .none }

        switch step {
        case .techCodeIsRequired:
            return navigateToTechCode()

        case .popToWritableReview:
            return popToWritableReview()
        }
    }
}

private extension TechCodeFlow {
    func navigateToTechCode() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func popToWritableReview() -> FlowContributors {
        self.rootViewController.dismissBottomSheet()
//        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
