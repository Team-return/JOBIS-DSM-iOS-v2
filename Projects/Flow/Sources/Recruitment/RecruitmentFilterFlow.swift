import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class RecruitmentFilterFlow: Flow {
    public let container: Container
    private let rootViewController: RecruitmentFilterViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(RecruitmentFilterViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? RecruitmentFilterStep else { return .none }

        switch step {
        case .recruitmentFilterIsRequired:
            return navigateToRecruitmentFilter()

        case let .popToRecruitment(jobCode, techCode, years, status):
            return popToRecruitment(jobCode: jobCode ?? "", techCode: techCode, years: years, status: status)
        }
    }
}

private extension RecruitmentFilterFlow {
    func navigateToRecruitmentFilter() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.reactor
        ))
    }

    func popToRecruitment(jobCode: String, techCode: [String]?, years: [String]?, status: String?) -> FlowContributors {
        let recruitmentPopView = self.rootViewController.navigationController?.viewControllers.first as? RecruitmentViewController
        let winterInternPopView = self.rootViewController.navigationController?.viewControllers.first(where: { $0 is WinterInternViewController}) as? WinterInternViewController

        // Update filter options via reactor action
        recruitmentPopView?.reactor.action.onNext(
            .updateFilterOptions(jobCode: jobCode, techCode: techCode, years: years, status: status)
        )
        recruitmentPopView?.reactor.action.onNext(.fetchRecruitmentList)

        winterInternPopView?.reactor.action.onNext(
            .updateFilterOptions(jobCode: jobCode, techCode: techCode)
        )
        winterInternPopView?.reactor.action.onNext(.fetchRecruitmentList)

        self.rootViewController.navigationController?.popViewController(animated: true)

        return .none
    }
}
