import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class CompanyFlow: Flow {
    public let container: Container
    private let rootViewController: CompanyViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(CompanyViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CompanyStep else { return .none }

        switch step {
        case .companyIsRequired:
            return navigateToCompany()
        case let .companyDetailIsRequired(id):
            return navigateToCompanyDetail(id)
        case .searchCompanyIsRequired:
            return navigateToSearchCompany()
        }
    }
}

private extension CompanyFlow {
    func navigateToCompany() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
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

    func navigateToSearchCompany() -> FlowContributors {
        let searchCompanyFlow = SearchCompanyFlow(container: container)

        Flows.use(searchCompanyFlow, when: .created) { (root) in
            let view = root as? SearchCompanyViewController
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: searchCompanyFlow,
            withNextStepper: OneStepper(withSingleStep: SearchCompanyStep.searchCompanyIsRequired)
        ))
    }
}
