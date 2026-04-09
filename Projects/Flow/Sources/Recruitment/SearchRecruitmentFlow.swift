import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class SearchRecruitmentFlow: Flow {
    public let container: Container
    private let rootViewController: SearchRecruitmentViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(SearchRecruitmentViewController.self)!
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
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToRecruitmentDetail(_ recruitmentId: Int) -> FlowContributors {
        let recruitmentDetailFlow = RecruitmentDetailFlow(
            container: container,
            recruitmentID: recruitmentId
        )

        Flows.use(recruitmentDetailFlow, when: .created) { (root) in
            let view = root as? RecruitmentDetailViewController
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
