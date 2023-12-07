import UIKit
import RxFlow
import RxSwift
import Core
import Swinject

public final class AppFlow: Flow {
    public var window: UIWindow
    public var root: Presentable {
        return self.window
    }
    public var container: Container

    public init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .onboardingIsRequired:
            return self.navigationToOnboarding()

        case .tabsIsRequired:
            return self.navigationToTabs()
        }
    }
}

extension AppFlow {
    func navigationToOnboarding() -> FlowContributors {
        let onboardingFlow = OnboardingFlow(container: container)
        Flows.use(onboardingFlow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(
            flowContributor: .contribute(
                withNextPresentable: onboardingFlow,
                withNextStepper: OneStepper(
                    withSingleStep: OnboardingStep.onboardingIsRequired
                )
            )
        )
    }

    func navigationToTabs() -> FlowContributors {
        let tabsFlow = TabsFlow(container: container)
        Flows.use(tabsFlow, when: .created) { (root) in
            UIView.transition(with: self.window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.window.rootViewController = root
            })
        }
        return .one(
            flowContributor: .contribute(
                withNextPresentable: tabsFlow,
                withNextStepper: OneStepper(
                    withSingleStep: TabsStep.tabsIsRequired
                )
            )
        )
    }
}
