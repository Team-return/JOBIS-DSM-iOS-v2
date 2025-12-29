import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class WinterInternDetailFlow: Flow {
    public let container: Container
    private let rootViewController: WinterInternDetailViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(WinterInternDetailViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? RecruitmentDetailStep else { return .none }

        switch step {
        case .recruitmentDetailIsRequired:
            return navigateToRecruitmentDetail()

        case let .companyDetailIsRequired(id):
            return navigateToCompanyDetail(id)

        case let .applyIsRequired(id, name, imageURL):
            return navigateToApply(id: id, name: name, imageURL: imageURL)
        }
    }
}

private extension WinterInternDetailFlow {
    func navigateToRecruitmentDetail() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func navigateToCompanyDetail(_ companyDetailId: Int) -> FlowContributors {
        let companyDetailFlow = CompanyDetailFlow(
            container: container,
            companyId: companyDetailId,
            type: .recruitmentDetail
        )

        Flows.use(companyDetailFlow, when: .created) { (root) in
            self.rootViewController.navigationController?.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: companyDetailFlow,
            withNextStepper: OneStepper(
                withSingleStep: CompanyDetailStep.companyDetailIsRequired
            )
        ))
    }

    func navigateToApply(id: Int, name: String, imageURL: String) -> FlowContributors {
        let applyFlow = ApplyFlow(container: container)

        Flows.use(applyFlow, when: .created) { (root) in
            self.rootViewController.navigationController?.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: applyFlow,
            withNextStepper: OneStepper(
                withSingleStep: ApplyStep.applyIsRequired(recruitmentId: id, name: name, imageURL: imageURL)
            )
        ))
    }
}
