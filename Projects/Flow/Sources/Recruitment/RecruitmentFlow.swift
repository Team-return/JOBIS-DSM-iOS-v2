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

        case let .recruitmentDetailIsRequired(id):
            return navigateToRecruitmentDetail(recruitmentID: id)

        case .recruitmentSearchIsRequired:
            return navigateToRecruitmentSearch()
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

    func navigateToRecruitmentDetail(recruitmentID: Int) -> FlowContributors {
        let recruitmentDetailFlow = RecruitmentDetailFlow(container: container)

        Flows.use(recruitmentDetailFlow, when: .created) { (root) in
            let view = root as? RecruitmentDetailViewController
            view?.viewModel.recruitmentID = recruitmentID
            self.rootViewController.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentDetailFlow,
            withNextStepper: OneStepper(withSingleStep: RecruitmentDetailStep.recruitmentDetailIsRequired)
        ))
    }

    func navigateToRecruitmentSearch() -> FlowContributors {
        let recruitmentSearchFlow = RecruitmentSearchFlow(container: container)

        Flows.use(recruitmentSearchFlow, when: .created) { (root) in
            let view = root as? RecruitmentSearchViewController
            self.rootViewController.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentSearchFlow,
            withNextStepper: OneStepper(withSingleStep: RecruitmentSearchStep.recruitmentSearchIsRequired)
        ))
    }
}
