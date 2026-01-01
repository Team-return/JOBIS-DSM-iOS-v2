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

        case let .classEmploymentIsRequired(classNumber, year):
            return navigateToClassEmployment(classNumber, year: year)

        case let .employmentFilterIsRequired(currentYear):
            return navigateToEmploymentFilter(currentYear: currentYear)

        case let .applyYearFilter(year):
            return applyYearFilter(year: year)
        }
    }
}

private extension EmployStatusFlow {
    func navigateToEmployStatus() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToClassEmployment(_ classNumber: Int, year: Int) -> FlowContributors {
        let viewController = container.resolve(ClassEmploymentViewController.self, arguments: classNumber, year)!
        rootViewController.navigationController?.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewController.reactor
        ))
    }

    func navigateToEmploymentFilter(currentYear: Int) -> FlowContributors {
        let viewController = container.resolve(EmploymentFilterViewController.self)!
        rootViewController.navigationController?.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(
            withNextPresentable: viewController,
            withNextStepper: viewController.reactor
        ))
    }

    func applyYearFilter(year: Int) -> FlowContributors {
        rootViewController.navigationController?.popViewController(animated: true)
        rootViewController.reactor.updateYear(year)
        return .none
    }
}
