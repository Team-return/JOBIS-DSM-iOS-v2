import Core
import Domain
import RxFlow
import RxSwift
import RxCocoa
import Utility

public final class OnboardingViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let reissueTokenUaseCase: ReissueTokenUaseCase

    init(reissueTokenUaseCase: ReissueTokenUaseCase) {
        self.reissueTokenUaseCase = reissueTokenUaseCase
    }

    public struct Input {
        let navigateToSigninDidTap: Signal<Void>
        let navigateToSignupDidTap: Signal<Void>
        let viewAppear: PublishRelay<Void>
    }

    public struct Output {
        let animate: PublishRelay<Void>
        let showNavigationButton: PublishRelay<Void>
    }

    public func transform(_ input: Input) -> Output {
        let animate = PublishRelay<Void>()
        let showNavigationButton = PublishRelay<Void>()

        input.navigateToSigninDidTap.asObservable()
            .avoidDuplication
            .map { _ in OnboardingStep.signinIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.navigateToSignupDidTap.asObservable()
            .avoidDuplication
            .map { _ in OnboardingStep.signupIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .map { _ in animate.accept(()) }
            .flatMap { [self] in
                return reissueTokenUaseCase.execute()
                    .asCompletable()
                    .catch { _ in
                        showNavigationButton.accept(())
                        return .never()
                    }
                    .andThen(Single.just(OnboardingStep.tabsIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            animate: animate,
            showNavigationButton: showNavigationButton
        )
    }
}
