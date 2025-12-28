import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class SearchCompanyFlow: Flow {
    public let container: Container
    private let rootViewController: SearchCompanyViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(SearchCompanyViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SearchCompanyStep else { return .none }

        switch step {
        case .searchCompanyIsRequired:
            return navigateToSearchCompany()

        case let .companyDetailIsRequired(id):
            return navigateToCompanyDetail(id)
        }
    }
}

private extension SearchCompanyFlow {
    func navigateToSearchCompany() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func navigateToCompanyDetail(_ companyId: Int) -> FlowContributors {
        let companyDetailFlow = CompanyDetailFlow(container: container)

        Flows.use(companyDetailFlow, when: .created) { (root) in
            let view = root as? CompanyDetailViewController
            view?.viewModel.companyID = companyId
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
