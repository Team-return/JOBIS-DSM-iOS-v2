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
        self.rootViewController = ApplyViewController(container.resolve(ApplyReactor.self)!)
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

        case let .errorToast(message):
            return errorToast(message: message)
        }
    }
}

private extension ApplyFlow {
    func navigateToApply(id: Int, name: String, imageURL: String) -> FlowContributors {
        rootViewController.reactor.recruitmentId = id
        rootViewController.reactor.companyName = name
        rootViewController.reactor.companyImageURL = imageURL
        rootViewController.reactor.applyType = .apply

        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToReApply(id: Int, name: String, imageURL: String) -> FlowContributors {
        rootViewController.reactor.applicationId = id
        rootViewController.reactor.companyName = name
        rootViewController.reactor.companyImageURL = imageURL
        rootViewController.reactor.applyType = .reApply

        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func popToRecruitmentDetail() -> FlowContributors {
        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }

    func errorToast(message: String) -> FlowContributors {
        self.rootViewController.showJobisToast(text: message, inset: 92)
        return .none
    }
}
