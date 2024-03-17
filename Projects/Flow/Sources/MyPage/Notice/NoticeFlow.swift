import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class NoticeFlow: Flow {
    public let container: Container
    private let rootViewController: NoticeViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(NoticeViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? NoticeStep else { return .none }

        switch step {
        case .noticeIsRequired:
            return navigateToNotice()

        case let .noticeDetailIsRequired(id):
            return navigateToNoticeDetail(id)
        }
    }
}

private extension NoticeFlow {
    func navigateToNotice() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToNoticeDetail(_ id: Int) -> FlowContributors {
        let noticeDetailFlow = NoticeDetailFlow(container: container)

        Flows.use(noticeDetailFlow, when: .created) { (root) in
            let view = root as? NoticeDetailViewController
            view?.viewModel.noticeID = id
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: noticeDetailFlow,
            withNextStepper: OneStepper(withSingleStep: NoticeDetailStep.noticeDetailIsRequired)
        ))
    }
}
