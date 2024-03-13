import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class RecruitmentDetailFlow: Flow {
    public let container: Container
    private let rootViewController: RecruitmentDetailViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(RecruitmentDetailViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? RecruitmentDetailStep else { return .none }

        switch step {
        case .recruitmentDetailIsRequired:
            return navigateToRecruitmentDetail()

        case let .companyDetailIsRequired(id):
            return navigateToCompanyDetail(id)
        }
    }
}

private extension RecruitmentDetailFlow {
    func navigateToRecruitmentDetail() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToCompanyDetail(_ companyDetailId: Int) -> FlowContributors {
        let companyDetailFlow = CompanyDetailFlow(container: container)

        Flows.use(companyDetailFlow, when: .created) { (root) in
            let view = root as? CompanyDetailViewController
            view?.viewModel.companyID = companyDetailId
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: companyDetailFlow,
            withNextStepper: OneStepper(
                withSingleStep: CompanyDetailStep.companyDetailIsRequired
            )
        ))
    }
}
