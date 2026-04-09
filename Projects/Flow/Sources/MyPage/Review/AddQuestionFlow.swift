import UIKit
import Presentation
import Swinject
import RxFlow
import Core

public final class AddQuestionFlow: Flow {
    public let container: Container
    private let rootViewController: AddQuestionViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(AddQuestionViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AddQuestionStep else { return .none }

        switch step {
        case .addQuestionIsRequired:
            return navigateToAddQuestion()

        case .popViewController:
            return popViewController()

        case .completeAddQuestion:
            return completeAddQuestion()
        }
    }
}

private extension AddQuestionFlow {
    func navigateToAddQuestion() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: rootViewController,
            withNextStepper: rootViewController.viewModel
        ))
    }

    func popViewController() -> FlowContributors {
        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }

    func completeAddQuestion() -> FlowContributors {
        self.rootViewController.navigationController?.popViewController(animated: true)
        return .none
    }
}
