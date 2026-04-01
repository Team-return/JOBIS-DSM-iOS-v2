import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class CompanyDetailFlow: Flow {
    public let container: Container
    private var rootViewController: CompanyDetailViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CompanyDetailStep else { return .none }

        switch step {
        case let .companyDetailIsRequired(companyId, type):
            return navigateToCompanyDetail(companyId: companyId, type: type)

        case .popIsRequired:
            return popCompanyDetail()

        case let .recruitmentDetailIsRequired(id):
            return navigateToRecruitmentDetail(recruitmentID: id)

        case let .interviewReviewDetailIsRequired(id, name):
            return navigateToInterviewReviewDetail(id, name)
        }
    }
}

private extension CompanyDetailFlow {
    func navigateToCompanyDetail(
        companyId: Int,
        type: CompanyDetailPreviousViewType
    ) -> FlowContributors {
        rootViewController = container.resolve(
            CompanyDetailViewController.self,
            arguments: companyId, type
        )!
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func popCompanyDetail() -> FlowContributors {
        rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }

    func navigateToRecruitmentDetail(recruitmentID: Int) -> FlowContributors {
        let recruitmentDetailFlow = RecruitmentDetailFlow(container: container)

        Flows.use(recruitmentDetailFlow, when: .created) { (root) in
            let view = root as? RecruitmentDetailViewController
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentDetailFlow,
            withNextStepper: OneStepper(
                withSingleStep: RecruitmentDetailStep.recruitmentDetailIsRequired(
                    id: recruitmentID,
                    companyId: nil,
                    type: .companyDetail
                )
            )
        ))
    }

    func navigateToInterviewReviewDetail(_ id: Int, _ name: String) -> FlowContributors {
        let interviewReviewDetailFlow = InterviewReviewDetailFlow(container: container)

        Flows.use(interviewReviewDetailFlow, when: .created) { root in
            self.rootViewController.navigationController?.pushViewController(
                root,
                animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: interviewReviewDetailFlow,
            withNextStepper: OneStepper(
                withSingleStep: InterviewReviewDetailStep.interviewReviewDetailIsRequired(
                    reviewId: String(id)
                )
            )
        ))
    }
}
