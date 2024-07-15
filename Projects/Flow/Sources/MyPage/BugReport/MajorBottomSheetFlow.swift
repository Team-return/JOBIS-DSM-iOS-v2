import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class MajorBottomSheetFlow: Flow {
    public let container: Container
    private let rootViewController: MajorBottomSheetViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = MajorBottomSheetViewController(
            container.resolve(MajorBottomSheetViewModel.self)!,
            state: .custom(height: 300)
        )
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MajorBottomSheetStep else { return .none }

        switch step {
        case .majorBottomSheetIsRequired:
            return navigateToMajorBottomSheet()
        }
    }
}

private extension MajorBottomSheetFlow {
    func navigateToMajorBottomSheet() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

//    func navigateToReApply(
//        _ recruitmentID: Int,
//        _ applicationID: Int,
//        _ companyName: String,
//        _ companyImageUrl: String
//    ) -> FlowContributors {
//        rootViewController.dismissBottomSheet()
//        return .end(forwardToParentFlowWithStep: HomeStep.reApplyIsRequired(
//            recruitmentID: recruitmentID,
//            applicationID: applicationID,
//            companyName: companyName,
//            companyImageURL: companyImageUrl
//        ))
//    }
}
