import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class HomeFlow: Flow {
    public let container: Container
    private let rootViewController = BaseNavigationController()
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return .none }

        switch step {
        case .homeIsRequired:
            return navigateToHome()

        case .alarmIsRequired:
            return navigateToAlarm()

        case .companySearchIsRequired:
            return navigateToCompanySearch()

        case let .rejectReasonIsRequired(recruitmentID, applicationID, companyName, companyImageUrl):
            return navigateToRejectReason(recruitmentID, applicationID, companyName, companyImageUrl)

        case let .reApplyIsRequired(recruitmentID, applicationID, companyName, companyImageURL):
            return navigateToReApply(recruitmentID, applicationID, companyName, companyImageURL)
        }
    }
}

private extension HomeFlow {
    func navigateToHome() -> FlowContributors {
        let homeViewController = container.resolve(HomeViewController.self)!

        self.rootViewController.setViewControllers(
            [homeViewController],
            animated: true
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: homeViewController,
            withNextStepper: homeViewController.viewModel
        ))
    }

    func navigateToAlarm() -> FlowContributors {
        let alarmFlow = AlarmFlow(container: container)

        Flows.use(alarmFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: alarmFlow,
            withNextStepper: OneStepper(withSingleStep: AlarmStep.alarmIsRequired)
        ))
    }

    func navigateToCompanySearch() -> FlowContributors {
        let companySearchFlow = CompanySearchFlow(container: container)
        Flows.use(companySearchFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: companySearchFlow,
            withNextStepper: OneStepper(
                withSingleStep: CompanySearchStep.companySearchIsRequired
            )
        ))
    }

    func navigateToRejectReason(
        _ recruitmentID: Int,
        _ applicationID: Int,
        _ companyName: String,
        _ companyImageUrl: String
    ) -> FlowContributors {
        let rejectReasonFlow = RejectReasonFlow(container: container)
        Flows.use(rejectReasonFlow, when: .created) { root in
            let view = root as? RejectReasonViewController
            view?.viewModel.recruitmentID = recruitmentID
            view?.viewModel.applicationID = applicationID
            view?.viewModel.companyName = companyName
            view?.viewModel.companyImageUrl = companyImageUrl
            self.rootViewController.present(
                root,
                animated: false
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: rejectReasonFlow,
            withNextStepper: OneStepper(
                withSingleStep: RejectReasonStep.rejectReasonIsRequired
            )
        ))
    }

    func navigateToReApply(
        _ recruitmentID: Int,
        _ applicationID: Int,
        _ companyName: String,
        _ companyImageUrl: String
    ) -> FlowContributors {
        let applyFlow = ApplyFlow(container: container)
        Flows.use(applyFlow, when: .created) { root in
            let view = root as? ApplyViewController
            view?.viewModel.applyType = .reApply
            self.rootViewController.pushViewController(
                view!,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: applyFlow,
            withNextStepper: OneStepper(
                withSingleStep: ApplyStep.reApplyIsRequired(
                    applicationId: applicationID,
                    name: companyName,
                    imageURL: companyImageUrl
                )
            )
        ))
    }
}
