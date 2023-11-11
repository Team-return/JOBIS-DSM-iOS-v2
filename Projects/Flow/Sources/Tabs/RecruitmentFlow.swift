import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public class RecruitmentFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
    }

    private let rootViewController = BaseNavigationController()

    public func navigate(to step: Step) -> RxFlow.FlowContributors {
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
        self.rootViewController.setViewControllers([recruitmentViewController], animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentViewController,
            withNextStepper: recruitmentViewController.viewModel
        ))
    }
}
