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
        case .employStatusIsRequired:
            return navigateToEmployStatus()

        case .classEmploymentIsRequired(let classNumber):
            return navigateToClassEmployment(classNumber: classNumber)
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
    
    func navigateToClassEmployment(classNumber: Int) -> FlowContributors {
        let viewController = container.resolve(ClassEmploymentViewController.self, argument: classNumber)!
        rootViewController.navigationController?.pushViewController(viewController, animated: true)
        
        guard let stepper = viewController.viewModel as? Stepper else {
            return .none
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: stepper
        ))
    }
}
