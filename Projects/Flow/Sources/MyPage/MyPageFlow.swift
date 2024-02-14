import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class MyPageFlow: Flow {
    public let container: Container
    private let rootViewController = BaseNavigationController()
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MyPageStep else { return .none }

        switch step {
        case .myPageIsRequired:
            return navigateToMyPage()

        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: TabsStep.appIsRequired)

<<<<<<<< HEAD:Projects/Flow/Sources/MyPage/MyPageFlow.swift
        case .noticeIsRequired:
            return navigateToNotice()
        case .bugReportIsRequired:
            return navigateToBugReport()

        case .confirmIsRequired:
            return navigateToConfirmPassword()
        }
    }
}

private extension MyPageFlow {
    func navigateToMyPage() -> FlowContributors {
        let myPageViewController = container.resolve(MyPageViewController.self)!

        self.rootViewController.setViewControllers(
            [myPageViewController],
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: myPageViewController,
            withNextStepper: myPageViewController.viewModel
        ))
    }

<<<<<<<< HEAD:Projects/Flow/Sources/MyPage/MyPageFlow.swift
    func navigateToNotice() -> FlowContributors {
        let noticeFlow = NoticeFlow(container: container)

        Flows.use(noticeFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root, animated: true
========
    func navigateToBugReport() -> FlowContributors {
        let bugReportFlow = BugReportFlow(container: container)

        Flows.use(bugReportFlow, when: .created) { bug in
            self.rootViewController.pushViewController(
                bug, animated: true
>>>>>>>> d2cce6d (🧩 :: BugReport 추가):Projects/Flow/Sources/Tabs/MyPage/MyPageFlow.swift
            )
        }

        return .one(flowContributor: .contribute(
<<<<<<<< HEAD:Projects/Flow/Sources/MyPage/MyPageFlow.swift
            withNextPresentable: noticeFlow,
            withNextStepper: OneStepper(withSingleStep: NoticeStep.noticeIsRequired)
========
            withNextPresentable: bugReportFlow,
            withNextStepper: OneStepper(withSingleStep: BugReportStep.bugReportIsRequired)
>>>>>>>> d2cce6d (🧩 :: BugReport 추가):Projects/Flow/Sources/Tabs/MyPage/MyPageFlow.swift
        ))
    }

    func navigateToConfirmPassword() -> FlowContributors {
        let confirmPasswordFlow = ConfirmPasswordFlow(container: container)

        Flows.use(confirmPasswordFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: confirmPasswordFlow,
            withNextStepper: OneStepper(withSingleStep: ConfirmPasswordStep.confirmPasswordIsRequired)
        ))
    }
}
