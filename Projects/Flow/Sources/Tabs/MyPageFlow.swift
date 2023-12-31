import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class MyPageFlow: Flow {
    public var container: Container

    public var root: Presentable {
        return rootViewController
    }
    public init(container: Container) {
        self.container = container
    }

    private let rootViewController = BaseNavigationController()

    public func navigate(to step: Step) -> RxFlow.FlowContributors {
        guard let step = step as? MyPageStep else { return .none }

        switch step {
        case .myPageIsRequired:
            return navigateToMyPage()
        case .tabsIsRequired:
            return .end(forwardToParentFlowWithStep: TabsStep.appIsRequired)
        }
    }
}

private extension MyPageFlow {
    func navigateToMyPage() -> FlowContributors {
        let myPageViewController = container.resolve(MyPageViewController.self)!
        self.rootViewController.setViewControllers([myPageViewController], animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: myPageViewController,
            withNextStepper: myPageViewController.viewModel
        ))
    }
}
