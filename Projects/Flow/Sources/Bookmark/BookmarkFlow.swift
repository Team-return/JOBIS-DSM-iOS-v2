import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class BookmarkFlow: Flow {
    public let container: Container
    private let rootViewController = BaseNavigationController()
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BookmarkStep else { return .none }

        switch step {
        case .bookmarkIsRequired:
            return navigateToBookmark()
        case let .recruitmentDetailIsRequired(id):
            return navigateToRecruitmentDetail(id)
        }
    }
}

private extension BookmarkFlow {
    func navigateToBookmark() -> FlowContributors {
        let bookmarkViewController = container.resolve(BookmarkViewController.self)!

        self.rootViewController.setViewControllers(
            [bookmarkViewController],
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: bookmarkViewController,
            withNextStepper: bookmarkViewController.viewModel
        ))
    }

    func navigateToRecruitmentDetail(_ recruitmentID: Int) -> FlowContributors {
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
}
