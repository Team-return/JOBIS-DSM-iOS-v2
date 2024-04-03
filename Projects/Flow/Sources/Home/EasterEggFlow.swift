import UIKit
import SwiftUI
import Presentation
import Swinject
import RxFlow
import Core


public final class EasterEggFlow: Flow {
    public let container: Container
    private let rootViewController: RxFlowViewController
    public var root: Presentable {
        return rootViewController
    }

    public init(container: Container) {
        self.container = container
        self.rootViewController = container.resolve(EasterEggViewController.self)!
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? EasterEggStep else { return .none }

        switch step {
        case .easterEggIsRequired:
            return navigateToEasterEgg()
        }
    }
}

private extension EasterEggFlow {
    func navigateToEasterEgg() -> FlowContributors {
        return .one(flowContributor: .contribute(withNext: rootViewController))
    }
}
