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

        case let .classEmploymentIsRequired(classNumber):
            return navigateToClassEmployment(classNumber)

        case .employmentFilterIsRequired:
            return navigateToEmploymentFilter()

        case .popEmploymentFilter:
            return popEmploymentFilter()
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

    func navigateToClassEmployment(_ classNumber: Int) -> FlowContributors {
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

    func navigateToEmploymentFilter() -> FlowContributors {
        let viewController = container.resolve(EmploymentFilterViewController.self)!
        rootViewController.navigationController?.pushViewController(viewController, animated: true)

        guard let stepper = viewController.viewModel as? Stepper else {
            return .none
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: stepper
        ))
    }

    func popEmploymentFilter() -> FlowContributors {
        rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
