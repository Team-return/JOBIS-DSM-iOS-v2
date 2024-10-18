import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class WinterInternFlow: Flow {
    public let container: Container
    private let rootViewController: WinterInternViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(WinterInternViewController.self)!
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

private extension WinterInternFlow {
    func navigateToRecruitment() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToRecruitmentDetail(recruitmentID: Int) -> FlowContributors {
        let recruitmentDetailFlow = WinterInternDetailFlow(container: container)

        Flows.use(recruitmentDetailFlow, when: .created) { (root) in
            let view = root as? WinterInternDetailViewController
            view?.viewModel.recruitmentID = recruitmentID
            view?.isPopViewController = { id, bookmark in
                let popView = self.rootViewController
                var oldData = popView.viewModel.recruitmentData.value
                oldData.enumerated().forEach {
                    if $0.element.recruitID == id {
                        oldData[$0.offset].bookmarked = bookmark
                    }
                }
                popView.viewModel.recruitmentData.accept(oldData)
                popView.isTabNavigation = false
            }
            self.rootViewController.navigationController?.pushViewController(
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
            self.rootViewController.navigationController?.pushViewController(
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
            self.rootViewController.navigationController?.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentFilterFlow,
            withNextStepper: OneStepper(withSingleStep: RecruitmentFilterStep.recruitmentFilterIsRequired)
        ))
    }
}
