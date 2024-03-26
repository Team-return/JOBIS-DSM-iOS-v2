import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class RecruitmentSearchFlow: Flow {
    public let container: Container
    private let rootViewController: RecruitmentSearchViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(RecruitmentSearchViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? RecruitmentSearchStep else { return .none }

        switch step {
        case .recruitmentSearchIsRequired:
            return navigateToRecruitmentSearch()

        case let .recruitmentDetailIsRequired(id):
            return navigateToRecruitmentDetail(id)
        }
    }
}

private extension RecruitmentSearchFlow {
    func navigateToRecruitmentSearch() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToRecruitmentDetail(_ recruitmentId: Int) -> FlowContributors {
        let recruitmentDetailFlow = RecruitmentDetailFlow(container: container)

        Flows.use(recruitmentDetailFlow, when: .created) { (root) in
            let view = root as? RecruitmentDetailViewController
            view?.viewModel.recruitmentID = recruitmentId
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentDetailFlow,
            withNextStepper: OneStepper(withSingleStep: RecruitmentDetailStep.recruitmentDetailIsRequired)
        ))
    }
}
