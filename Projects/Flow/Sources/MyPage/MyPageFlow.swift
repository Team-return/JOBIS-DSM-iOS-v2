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

        case let .writableReviewIsRequired(id):
            return navigateToWritableReview(id)

        case .notificationSettingIsRequired:
            return navigateToNotification()

        case .noticeIsRequired:
            return navigateToNotice()

        case .bugReportIsRequired:
            return navigateToBugReport()

        case .confirmIsRequired:
            return navigateToConfirmPassword()

        case .bugReportListIsRequired:
            return .none
//            return navigateToBugReportList()

        case .interestFieldIsRequired:
            return navigateToInterestField()
        }
    }
}

extension MyPageFlow {
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

    func navigateToWritableReview(_ id: Int) -> FlowContributors {
        let writableReviewFlow = WritableReviewFlow(container: container)

        Flows.use(writableReviewFlow, when: .created) { (root) in
            let view = root as? WritableReviewViewController
            view?.viewModel.companyID = id
            self.rootViewController.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: writableReviewFlow,
            withNextStepper: OneStepper(withSingleStep: WritableReviewStep.writableReviewIsRequired)
        ))
    }

    func navigateToNotification() -> FlowContributors {
        let notificationSettingFlow = NotificationSettingFlow(container: container)

        Flows.use(notificationSettingFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: notificationSettingFlow,
            withNextStepper: OneStepper(withSingleStep: NotificationSettingStep.notificationSettingIsRequired)
        ))
    }

    func navigateToNotice() -> FlowContributors {
        let noticeFlow = NoticeFlow(container: container)

        Flows.use(noticeFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: noticeFlow,
            withNextStepper: OneStepper(withSingleStep: NoticeStep.noticeIsRequired)
        ))
    }

    func navigateToBugReport() -> FlowContributors {
        let bugReportFlow = BugReportFlow(container: container)

        Flows.use(bugReportFlow, when: .created) { bug in
            self.rootViewController.pushViewController(
                bug, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: bugReportFlow,
            withNextStepper: OneStepper(withSingleStep: BugReportStep.bugReportIsRequired)
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

    func navigateToInterestField() -> FlowContributors {
        let interestFieldFlow = InterestFieldFlow(container: container)

        Flows.use(interestFieldFlow, when: .created) { root in
                self.rootViewController.pushViewController(
                    root, animated: true
                )
            }

        return .one(flowContributor: .contribute(
            withNextPresentable: interestFieldFlow,
            withNextStepper: OneStepper(withSingleStep: InterestFieldStep.interestFieldIsRequired)
        ))
    }
//    func navigateToBugReportList() -> FlowContributors {
//        let bugReportListFlow = BugReportListFlow(container: container)
//
//        Flows.use(bugReportListFlow, when: .created) { root in
//            self.rootViewController.pushViewController(
//                root, animated: true
//            )
//        }
//
//        return .one(flowContributor: .contribute(
//            withNextPresentable: bugReportListFlow,
//            withNextStepper: OneStepper(withSingleStep: BugReportListStep.bugReportListIsRequired)
//        ))
//    }
}
