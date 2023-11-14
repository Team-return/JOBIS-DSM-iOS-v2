import Core
import RxFlow
import RxSwift
import RxCocoa

public final class OnboardingViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let disposeBag = DisposeBag()

    public struct Input {
        let navigateToSigninDidTap: Signal<Void>
        let navigateToSignupDidTap: Signal<Void>
    }

    public struct Output { }

    public func transform(_ input: Input) -> Output {
        input.navigateToSigninDidTap.asObservable()
            .map { _ in OnboardingStep.signinIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.navigateToSignupDidTap.asObservable()
            .map { _ in OnboardingStep.signupIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output()
    }
}
