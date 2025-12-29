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
        self.rootViewController = CompanyDetailViewController(container.resolve(CompanyDetailReactor.self)!)
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CompanyDetailStep else { return .none }

        switch step {
        case .companyDetailIsRequired:
            return navigateToCompanyDetail()

        case .popIsRequired:
            return popCompanyDetail()

        case let.recruitmentDetailIsRequired(id):
            return navigateToRecruimtentDetail(recruitmentID: id)

        case let .interviewReviewDetailIsRequired(id, name):
            return navigateToInterviewReviewDetail(id, name)
        }
    }
}

private extension CompanyDetailFlow {
    func navigateToCompanyDetail() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func popCompanyDetail() -> FlowContributors {
        rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }

    func navigateToRecruimtentDetail(recruitmentID: Int) -> FlowContributors {
        let recruitmentDetailFlow = RecruitmentDetailFlow(
            container: container,
            recruitmentID: recruitmentID,
            type: .companyDetail
        )

        Flows.use(recruitmentDetailFlow, when: .created) { (root) in
            let view = root as? RecruitmentDetailViewController
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: recruitmentDetailFlow,
            withNextStepper: OneStepper(withSingleStep: RecruitmentDetailStep.recruitmentDetailIsRequired)
        ))
    }

    func navigateToInterviewReviewDetail(_ id: Int, _ name: String) -> FlowContributors {
        let interviewReviewDetailFlow = InterviewReviewDetailFlow(container: container)

        Flows.use(interviewReviewDetailFlow, when: .created) { (root) in
            let view = root as? InterviewReviewDetailViewController
            view?.viewModel.reviewId = String(id)
            view?.viewModel.writerName = name
            self.rootViewController.navigationController?.pushViewController(
                view!, animated: true
            )
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: interviewReviewDetailFlow,
            withNextStepper: OneStepper(withSingleStep: InterviewReviewDetailStep.interviewReviewDetailIsRequired)
        ))
    }
}
