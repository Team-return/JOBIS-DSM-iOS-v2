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
        case .mainIsRequired:
            return self.navigationToMain()
        }
    }

    private func navigationToMain() -> FlowContributors {
        let mainFlow = MainFlow(container: container)
        Flows.use(mainFlow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(
            flowContributor: .contribute(
                withNextPresentable: mainFlow,
                withNextStepper: OneStepper(
                    withSingleStep: MainStep.loginIsRequired
                )
            )
        )
    }
}
