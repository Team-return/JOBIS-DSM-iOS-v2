import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class CompanySearchFlow: Flow {
    public let container: Container
    private let rootViewController: CompanySearchViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(CompanySearchViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CompanySearchStep else { return .none }

        switch step {
        case .companySearchIsRequired:
            return navigateToCompanySearch()
        case let .companyDetailIsRequired(id):
            return navigateToCompanyDetail(id)
        }
    }
}

private extension CompanySearchFlow {
    func navigateToCompanySearch() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToCompanyDetail(_ id: Int) -> FlowContributors {
        let companyDetailFlow = CompanyDetailFlow(container: container)

        Flows.use(companyDetailFlow, when: .created) { (root) in
            let view = root as? CompanyDetailViewController
            view?.viewModel.companyID = id
            view?.viewModel.type = .searchCompany
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: companyDetailFlow,
            withNextStepper: OneStepper(withSingleStep: CompanyDetailStep.companyDetailIsRequired)
        ))
    }
}
