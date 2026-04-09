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

        case .recruitmentFilterIsRequired:
            return navigateToRecruitmentFilter()

        case .searchRecruitmentIsRequired:
            return navigateToSearchRecruitment()
        }
    }
}

private extension RecruitmentFlow {
    func navigateToRecruitment() -> FlowContributors {
        let recruitmentViewController = container.resolve(RecruitmentViewController.self)!
        recruitmentViewController.viewWillappearWithTap = {
            recruitmentViewController.viewDidLoadPublisher.accept(())
        }

        self.rootViewController.setViewControllers(
            [recruitmentViewController],
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentViewController,
            withNextStepper: recruitmentViewController.reactor
        ))
    }

    func navigateToRecruitmentDetail(recruitmentID: Int) -> FlowContributors {
        let recruitmentDetailFlow = RecruitmentDetailFlow(
            container: container,
            recruitmentID: recruitmentID
        )

        Flows.use(recruitmentDetailFlow, when: .created) { (root) in
            let view = root as? RecruitmentDetailViewController
            view?.isPopViewController = { id, bookmark in
                // In ReactorKit, state is immutable
                // The list will be refreshed on viewWillAppear if needed
                let popView = self.rootViewController.topViewController as? RecruitmentViewController
                popView?.isTabNavigation = false
            }
            self.rootViewController.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentDetailFlow,
            withNextStepper: OneStepper(withSingleStep: RecruitmentDetailStep.recruitmentDetailIsRequired)
        ))
    }

    func navigateToSearchRecruitment() -> FlowContributors {
        let searchRecruitmentFlow = SearchRecruitmentFlow(container: container)

        Flows.use(searchRecruitmentFlow, when: .created) { (root) in
            let view = root as? SearchRecruitmentViewController
            self.rootViewController.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: searchRecruitmentFlow,
            withNextStepper: OneStepper(withSingleStep: SearchRecruitmentStep.searchRecruitmentIsRequired)
        ))
    }

    func navigateToRecruitmentFilter() -> FlowContributors {
        let recruitmentFilterFlow = RecruitmentFilterFlow(container: container)

        Flows.use(recruitmentFilterFlow, when: .created) { (root) in
            self.rootViewController.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentFilterFlow,
            withNextStepper: OneStepper(withSingleStep: RecruitmentFilterStep.recruitmentFilterIsRequired)
        ))
    }
}
