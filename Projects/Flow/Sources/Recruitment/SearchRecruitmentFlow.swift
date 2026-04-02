import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class SearchRecruitmentFlow: Flow {
    public let container: Container
    private var rootViewController: SearchRecruitmentViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SearchRecruitmentStep else { return .none }

        switch step {
        case .searchRecruitmentIsRequired:
            return navigateToSearchRecruitment()

        case let .recruitmentDetailIsRequired(id):
            return navigateToRecruitmentDetail(id)
        }
    }
}

private extension SearchRecruitmentFlow {
    func navigateToSearchRecruitment() -> FlowContributors {
        rootViewController = container.resolve(SearchRecruitmentViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToRecruitmentDetail(_ recruitmentId: Int) -> FlowContributors {
        let recruitmentDetailFlow = RecruitmentDetailFlow(container: container)

        Flows.use(recruitmentDetailFlow, when: .created) { (root) in
            let view = root as? RecruitmentDetailViewController
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentDetailFlow,
            withNextStepper: OneStepper(
                withSingleStep: RecruitmentDetailStep.recruitmentDetailIsRequired(
                    id: recruitmentId,
                    companyId: nil,
                    type: .recruitmentList
                )
            )
        ))
    }
}
