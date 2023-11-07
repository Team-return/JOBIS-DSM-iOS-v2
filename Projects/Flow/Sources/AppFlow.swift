import UIKit
import RxFlow
import RxSwift
import Core
import Swinject

public class AppFlow: Flow {
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
        }
    }

    private func navigationToOnboarding() -> FlowContributors {
        let onboardingFlow = OnboardingFlow(container: container)
        Flows.use(onboardingFlow, when: .created) { root in
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
}
