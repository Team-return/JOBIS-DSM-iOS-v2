import UIKit
import RxFlow
import Core
import Presentation
import DesignSystem
import Swinject

public class TabsFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }

    init(container: Container) {
        self.container = container
    }

    private let rootViewController = BaseTabBarController()

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TabsStep else { return .none }

        switch step {
        case .tabsIsRequired:
            return navigateToTabs()
        }
    }
}

// swiftlint: disable function_body_length
private extension TabsFlow {
    private func navigateToTabs() -> FlowContributors {
        let homeFlow = HomeFlow(container: container)
        let recruitmentFlow = RecruitmentFlow(container: container)
        let bookmarkFlow = BookmarkFlow(container: container)
        let myPageFlow = MyPageFlow(container: container)

        Flows.use(
            homeFlow,
            recruitmentFlow,
            bookmarkFlow,
            myPageFlow,
            when: .created
        ) { [weak self] home, recruitment, bookmark, mypage in
            home.tabBarItem = JobisTabBarItem(.home)
            recruitment.tabBarItem = JobisTabBarItem(.recruitment)
            bookmark.tabBarItem = JobisTabBarItem(.bookmark)
            mypage.tabBarItem = JobisTabBarItem(.myPage)
            self?.rootViewController.setViewControllers([
                home, recruitment, bookmark, mypage
            ], animated: false)
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
                withNextPresentable: bookmarkFlow,
                withNextStepper: OneStepper(withSingleStep: BookmarkStep.bookmarkIsRequired)
            ),
            .contribute(
                withNextPresentable: myPageFlow,
                withNextStepper: OneStepper(withSingleStep: MyPageStep.myPageIsRequired)
            )
        ])
    }
}
// swiftlint: enable function_body_length
