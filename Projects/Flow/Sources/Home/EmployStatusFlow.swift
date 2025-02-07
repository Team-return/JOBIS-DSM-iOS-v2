import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class EmployStatusFlow: Flow {
    public let container: Container
    private let rootViewController: EmployStatusViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(EmployStatusViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? EmployStatusStep else { return .none }

        switch step {
        case .emplyStatusIsRequired:
            return navigateToEmployStatus()
        }
    }
}

private extension EmployStatusFlow {
    func navigateToEmployStatus() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
