import UIKit
import RxFlow
import Core
import Presentation
import DesignSystem
import Swinject

public final class TabsFlow: Flow {
    public let container: Container
    private let rootViewController = BaseTabBarController()
    public var root: Presentable {
        return rootViewController
    }

    init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TabsStep else { return .none }

        switch step {
        case .tabsIsRequired:
            return navigateToTabs()

        case .appIsRequired:
            return dismissToOnbording()
        }
    }
}

private extension TabsFlow {
    private func navigateToTabs() -> FlowContributors {
        let homeFlow = HomeFlow(container: container)
        let recruitmentFlow = RecruitmentFlow(container: container)
        let reviewFlow = ReviewFlow(container: container)
        let bookmarkFlow = BookmarkFlow(container: container)
        let myPageFlow = MyPageFlow(container: container)

        Flows.use(
            homeFlow,
            recruitmentFlow,
            reviewFlow,
            bookmarkFlow,
            myPageFlow,
            when: .created
        ) { [weak self] home, recruitment, review, bookmark, mypage in
            home.tabBarItem = JobisTabBarItem(.home)
            recruitment.tabBarItem = JobisTabBarItem(.recruitment)
            review.tabBarItem = JobisTabBarItem(.review)
            bookmark.tabBarItem = JobisTabBarItem(.bookmark)
            mypage.tabBarItem = JobisTabBarItem(.myPage)

            self?.rootViewController.setViewControllers(
                [
                    home,
                    recruitment,
                    review,
                    bookmark,
                    mypage
                ],
                animated: false
            )
        }

        return .multiple(flowContributors: [
            .contribute(
                withNextPresentable: homeFlow,
                withNextStepper: OneStepper(withSingleStep: HomeStep.homeIsRequired)
            ),
            .contribute(
                withNextPresentable: recruitmentFlow,
                withNextStepper: OneStepper(withSingleStep: RecruitmentStep.recruitmentIsRequired)
            ),
            .contribute(
                withNextPresentable: reviewFlow,
                withNextStepper: OneStepper(withSingleStep: ReviewStep.reviewIsRequired)
            ),
            .contribute(
                withNextPresentable: bookmarkFlow,
                withNextStepper: OneStepper(withSingleStep: BookmarkStep.bookmarkIsRequired)
            ),
            .contribute(
                withNextPresentable: myPageFlow,
                withNextStepper: OneStepper(withSingleStep: MyPageStep.myPageIsRequired)
            )
        ])
    }

    private func dismissToOnbording() -> FlowContributors {
        UIView.transition(
            with: self.rootViewController.view.window!,
            duration: 0.5,
            options: .transitionCrossDissolve) {
                self.rootViewController.dismiss(animated: false)
            }

        return .end(forwardToParentFlowWithStep: AppStep.onboardingIsRequired)
    }
}
