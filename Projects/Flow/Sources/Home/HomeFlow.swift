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

        case .companyIsRequired:
            return navigateToCompany()

        case .winterInternIsRequired:
            return navigateToWinterIntern()

        case .easterEggIsRequired:
            return navigateToEasterEgg()

        case let .rejectReasonIsRequired(recruitmentID, applicationID, companyName, companyImageUrl):
            return navigateToRejectReason(recruitmentID, applicationID, companyName, companyImageUrl)

        case let .reApplyIsRequired(recruitmentID, applicationID, companyName, companyImageURL):
            return navigateToReApply(recruitmentID, applicationID, companyName, companyImageURL)

        case let .recruitmentDetailIsRequired(id):
            return navigateToRecruitmentDetail(id)

        case .employStatusIsRequired:
            return navigateToEmployStatus()
        case .none:
            return .none
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

    func navigateToEasterEgg() -> FlowContributors {
        let easterEggFlow = EasterEggFlow(container: container)

        Flows.use(easterEggFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: easterEggFlow,
            withNextStepper: OneStepper(withSingleStep: EasterEggStep.easterEggIsRequired)
        ))
    }

    func navigateToCompany() -> FlowContributors {
        let companyFlow = CompanyFlow(container: container)
        Flows.use(companyFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: companyFlow,
            withNextStepper: OneStepper(
                withSingleStep: CompanyStep.companyIsRequired
            )
        ))
    }

    func navigateToWinterIntern() -> FlowContributors {
        let winterInternFlow = WinterInternFlow(container: container)
        Flows.use(winterInternFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: winterInternFlow,
            withNextStepper: OneStepper(
                withSingleStep: RecruitmentStep.recruitmentIsRequired
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

    func navigateToRecruitmentDetail(_ recruitmentID: Int) -> FlowContributors {
        let recruitmentDetailFlow = RecruitmentDetailFlow(container: container)

        Flows.use(recruitmentDetailFlow, when: .created) { (root) in
            let view = root as? RecruitmentDetailViewController
            view?.viewModel.recruitmentID = recruitmentID
            view?.isPopViewController = { id, bookmark in
                let popView = self.rootViewController.topViewController as? RecruitmentViewController
                var oldData = popView?.viewModel.recruitmentData.value
                oldData?.enumerated().forEach {
                    if $0.element.recruitID == id {
                        oldData![$0.offset].bookmarked = bookmark
                    }
                }
                popView?.viewModel.recruitmentData.accept(oldData!)
                popView?.isTabNavigation = false
            }
            self.rootViewController.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentDetailFlow,
            withNextStepper: OneStepper(withSingleStep: RecruitmentDetailStep.recruitmentDetailIsRequired)
        ))
    }

    func navigateToEmployStatus() -> FlowContributors {
        let employStatusFlow = EmployStatusFlow(container: container)

        Flows.use(employStatusFlow, when: .created) { root in
            self.rootViewController.pushViewController(
                root, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: employStatusFlow,
            withNextStepper: OneStepper(withSingleStep: EmployStatusStep.employStatusIsRequired)
        ))
    }
}
