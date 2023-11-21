import Core
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class OnboardingViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let reissueTokenUaseCase: ReissueTokenUaseCase

    private let disposeBag = DisposeBag()
    init(reissueTokenUaseCase: ReissueTokenUaseCase) {
        self.reissueTokenUaseCase = reissueTokenUaseCase
    }

    public struct Input {
        let navigateToSigninDidTap: Signal<Void>
        let navigateToSignupDidTap: Signal<Void>
        let viewAppear: PublishRelay<Void>
    }

    public struct Output {
        let animation: PublishRelay<Void>
    }

    public func transform(_ input: Input) -> Output {
        let animation = PublishRelay<Void>()
        input.navigateToSigninDidTap.asObservable()
            .map { _ in OnboardingStep.signinIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.navigateToSignupDidTap.asObservable()
            .map { _ in OnboardingStep.signupIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        input.viewAppear.asObservable()
            .flatMap { [self] in
                reissueTokenUaseCase.execute()
                    .asCompletable()
                    .catch { _ in
                        animation.accept(())
                        return .never()
                    }
                    .andThen(Single.just(OnboardingStep.tabsIsRequired))
            }
            .delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output(animation: animation)
    }
}
