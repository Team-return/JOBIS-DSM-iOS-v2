import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class BugReportFlow: Flow {
    public let container: Container
    private let rootViewController: BugReportViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(BugReportViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? BugReportStep else { return .none }

        switch step {
        case .bugReportIsRequired:
            return navigateToBugReport()

        case .majorBottomSheetIsRequired:
            return navigateToMajorBottomSheet()
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

    func navigateToMajorBottomSheet() -> FlowContributors {
        let majorBottomSheetFlow = MajorBottomSheetFlow(container: container)

        Flows.use(majorBottomSheetFlow, when: .created) { (root) in
            let view = root as? MajorBottomSheetViewController
            self.rootViewController.present(
                root,
                animated: false
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: majorBottomSheetFlow,
            withNextStepper: OneStepper(withSingleStep: MajorBottomSheetStep.majorBottomSheetIsRequired)
        ))
    }
}
