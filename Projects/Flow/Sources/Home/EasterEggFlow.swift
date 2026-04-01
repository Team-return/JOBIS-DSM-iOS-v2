import UIKit
import SwiftUI
import Presentation
import Swinject
import RxFlow
import Core

public final class EasterEggFlow: Flow {
    public let container: Container
    private var rootViewController: EasterEggViewController!
    public var root: Presentable { rootViewController! }

    public init(container: Container) {
        self.container = container
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
        rootViewController = container.resolve(EasterEggViewController.self)!
        return .one(flowContributor: .contribute(withNext: rootViewController))
    }
}
