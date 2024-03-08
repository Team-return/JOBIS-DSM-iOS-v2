import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class CompanyDetailFlow: Flow {
    public let container: Container
    private let rootViewController: CompanyDetailViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(CompanyDetailViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CompanyDetailStep else { return .none }

        switch step {
        case .companyDetailIsRequired:
            return navigateToCompanyDetail()

        case .recruitmentDetailIsRequired:
            return dismissCompanyDetail()
        }
    }
}

private extension CompanyDetailFlow {
    func navigateToCompanyDetail() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func dismissCompanyDetail() -> FlowContributors {
        rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
