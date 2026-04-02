import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class NoticeFlow: Flow {
    public let container: Container
    private var rootViewController: NoticeViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
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
        rootViewController = container.resolve(NoticeViewController.self)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToNoticeDetail(_ id: Int) -> FlowContributors {
        let noticeDetailFlow = NoticeDetailFlow(container: container)

        Flows.use(noticeDetailFlow, when: .created) { (root) in
            let view = root as? NoticeDetailViewController
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: noticeDetailFlow,
            withNextStepper: OneStepper(withSingleStep: NoticeDetailStep.noticeDetailIsRequired(noticeID: id))
        ))
    }
}
