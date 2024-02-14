import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class BugReportFlow: Flow {
    public let container: Container
    public var root: Presentable {
        return rootViewController
    }
    private let rootViewController: BugReportViewController

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(BugReportViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BugReportStep else { return .none }

        switch step {
        case .bugReportIsRequired:
            return navigateToBugReport()
        }
    }
}

private extension BugReportFlow {
    func navigateToBugReport() -> FlowContributors {

        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }
}
