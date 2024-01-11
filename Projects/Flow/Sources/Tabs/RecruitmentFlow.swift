import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class RecruitmentFlow: Flow {
    public let container: Container
    private let rootViewController = BaseNavigationController()
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? RecruitmentStep else { return .none }

        switch step {
        case .recruitmentIsRequired:
            return navigateToRecruitment()
        }
    }
}

private extension RecruitmentFlow {
    func navigateToRecruitment() -> FlowContributors {
        let recruitmentViewController = container.resolve(RecruitmentViewController.self)!

        self.rootViewController.setViewControllers(
            [recruitmentViewController],
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentViewController,
            withNextStepper: recruitmentViewController.viewModel
        ))
    }
}
