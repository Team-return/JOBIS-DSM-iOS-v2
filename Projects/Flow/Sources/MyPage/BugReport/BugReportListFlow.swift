//import UIKit
//import Presentation
//import Swinject
//import RxFlow
//import Core
//
//public final class BugReportListFlow: Flow {
//    public let container: Container
//    private let rootViewController: BugReportListViewController
//    public var root: Presentable {
//        return rootViewController
//    }
//
//    public init(container: Container) {
//        self.container = container
//        self.rootViewController = container.resolve(BugReportListViewController.self)!
//    }
//
//    public func navigate(to step: Step) -> FlowContributors {
//        guard let step = step as? BugReportListStep else { return .none }
//
//        switch step {
//        case .bugReportListIsRequired:
//            return navigateToBugReportList()
//
//        case .majorBottomSheetIsRequired:
//            return navigateToMajorBottomSheet()
//        }
//    }
//}
//
//private extension BugReportListFlow {
//    func navigateToBugReportList() -> FlowContributors {
//        return .one(flowContributor: .contribute(
//            withNextPresentable: rootViewController,
//            withNextStepper: rootViewController.viewModel
//        ))
//    }
//
//    func navigateToMajorBottomSheet() -> FlowContributors {
//        let majorBottomSheetFlow = MajorBottomSheetFlow(container: container)
//
//        Flows.use(majorBottomSheetFlow, when: .created) { (root) in
//            let view = root as? MajorBottomSheetViewController
//            self.rootViewController.present(
//                root,
//                animated: false
//            )
//        }
//
//        return .one(flowContributor: .contribute(
//            withNextPresentable: majorBottomSheetFlow,
//            withNextStepper: OneStepper(withSingleStep: MajorBottomSheetStep.majorBottomSheetIsRequired)
//        ))
//    }
//}
