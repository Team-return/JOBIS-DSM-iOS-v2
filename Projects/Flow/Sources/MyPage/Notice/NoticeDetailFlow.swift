import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class NoticeDetailFlow: Flow {
    public let container: Container
    private var rootViewController: NoticeDetailViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? NoticeDetailStep else { return .none }

        switch step {
        case let .noticeDetailIsRequired(noticeID):
            return navigateToNoticeDetail(noticeID: noticeID)
        case .noticeListIsRequired:
            return popNoticeList()
        }
    }
}

private extension NoticeDetailFlow {
    func navigateToNoticeDetail(noticeID: Int) -> FlowContributors {
        rootViewController = container.resolve(NoticeDetailViewController.self, argument: noticeID)!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func popNoticeList() -> FlowContributors {
        rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
