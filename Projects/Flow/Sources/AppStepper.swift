import Foundation
import RxCocoa
import RxFlow
import RxSwift
import Core

public final class AppStepper: Stepper {

    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public init() {}

    public var initialStep: Step {
        return AppStep.onboardingIsRequired
    }
}
