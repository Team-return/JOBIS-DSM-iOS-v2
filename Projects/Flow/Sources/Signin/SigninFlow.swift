import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public class SigninFlow: Flow {
    public var container: Container

    public var window: UIWindow
    public var root: Presentable {
        return rootViewController
    }
    public init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        self.rootViewController = SigninViewController(container.resolve(SigninViewModel.self)!)
    }

    private let rootViewController: SigninViewController

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SigninStep else { return .none }

        switch step {
        case .signinIsRequired:
            return navigateToSignin()
        case .tabsIsRequired:
            print("navigate to tabs")
            return navigationToTabs()
        }
    }
}

private extension SigninFlow {
    func navigateToSignin() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigationToTabs() -> FlowContributors {
        let tabsFlow = TabsFlow(container: container)
        Flows.use(tabsFlow, when: .created) { (root) in
            self.window.rootViewController = root
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
