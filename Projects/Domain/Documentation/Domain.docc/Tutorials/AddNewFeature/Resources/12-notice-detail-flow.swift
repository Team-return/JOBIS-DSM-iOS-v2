import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class NoticeDetailFlow: Flow {
    public let container: Container

    // ✅ private let (var 아님) — init에서 resolve하므로 항상 non-nil
    private let rootViewController: NoticeDetailViewController

    public var root: Presentable {
        return rootViewController
    }

    // ✅ noticeID를 init에서 받아 즉시 resolve
    // ❌ navigate(to:) 안에서 resolve하면 flow.root 접근 시 nil 크래시 발생
    public init(container: Container, noticeID: Int) {
        self.container = container
        self.rootViewController = container.resolve(
            NoticeDetailViewController.self,
            argument: noticeID
        )!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? NoticeDetailStep else { return .none }

        switch step {
        case .noticeDetailIsRequired:
            return navigateToNoticeDetail()
        case .noticeListIsRequired:
            rootViewController.navigationController?.popViewController(animated: true)
            return .none
        }
    }
}

private extension NoticeDetailFlow {
    func navigateToNoticeDetail() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }
}
