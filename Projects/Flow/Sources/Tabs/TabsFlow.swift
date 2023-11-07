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

    private let rootViewController = UITabBarController().then {
        $0.tabBar.tintColor = .GrayScale.gray90
        $0.tabBar.unselectedItemTintColor = .GrayScale.gray50
        $0.tabBar.backgroundColor = .GrayScale.gray10

        let stroke = UIView().then {
            $0.backgroundColor = .GrayScale.gray30
        }

        $0.tabBar.addSubview(stroke)
        stroke.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

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
            let homeTabBarItem = UITabBarItem(
                title: "홈",
                image: DesignSystemAsset.Icons.homeTab.image,
                tag: 0
            ).then {
                $0.setTitleTextAttributes([.font: UIFont.jobisFont(.cation)], for: .normal)
            }
            let recruitmentTabBarItem = UITabBarItem(
                title: "모집의뢰서",
                image: DesignSystemAsset.Icons.recruitmentTab.image,
                tag: 1
            ).then {
                $0.setTitleTextAttributes([.font: UIFont.jobisFont(.cation)], for: .normal)
            }
            let bookmarkTabBarItem = UITabBarItem(
                title: "북마크",
                image: DesignSystemAsset.Icons.bookmarkTab.image,
                tag: 2
            ).then {
                $0.setTitleTextAttributes([.font: UIFont.jobisFont(.cation)], for: .normal)
            }
            let myPageTabBarItem = UITabBarItem(
                title: "마이페이지",
                image: DesignSystemAsset.Icons.mypageTab.image,
                tag: 3
            ).then {
                $0.setTitleTextAttributes([.font: UIFont.jobisFont(.cation)], for: .normal)
            }

            home.tabBarItem = homeTabBarItem
            recruitment.tabBarItem = recruitmentTabBarItem
            bookmark.tabBarItem = bookmarkTabBarItem
            mypage.tabBarItem = myPageTabBarItem
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
