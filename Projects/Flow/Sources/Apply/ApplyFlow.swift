import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class ApplyFlow: Flow {
    public let container: Container
    private let rootViewController: ApplyViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(ApplyViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ApplyStep else { return .none }

        switch step {
        case let .applyIsRequired(id, name, imageURL):
            return navigateToApply(id: id, name: name, imageURL: imageURL)
        case .popToRecruitmentDetail:
            return popToRecruitmentDetail()
        case let .reApplyIsRequired(id, name, imageURL):
            return navigateToReApply(id: id, name: name, imageURL: imageURL)
        }
    }
}

private extension ApplyFlow {
    func navigateToApply(id: Int, name: String, imageURL: String) -> FlowContributors {
        rootViewController.viewModel.recruitmentId = id
        rootViewController.viewModel.companyName = name
        rootViewController.viewModel.companyImageURL = imageURL

        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToReApply(id: Int, name: String, imageURL: String) -> FlowContributors {
        rootViewController.viewModel.applicationId = id
        rootViewController.viewModel.companyName = name
        rootViewController.viewModel.companyImageURL = imageURL

        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func popToRecruitmentDetail() -> FlowContributors {
        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
