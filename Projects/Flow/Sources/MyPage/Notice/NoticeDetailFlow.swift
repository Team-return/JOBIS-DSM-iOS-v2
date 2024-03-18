import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class NoticeDetailFlow: Flow {
    public let container: Container
    private let rootViewController: NoticeDetailViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(NoticeDetailViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? NoticeDetailStep else { return .none }

        switch step {
        case .noticeDetailIsRequired:
            return navigateToNoticeDetail()
        case .noticeListIsRequired:
            return popNoticeList()
        }
    }
}

private extension NoticeDetailFlow {
    func navigateToNoticeDetail() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func popNoticeList() -> FlowContributors {
        rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
