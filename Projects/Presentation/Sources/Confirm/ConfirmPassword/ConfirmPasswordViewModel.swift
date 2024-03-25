import Core
import DesignSystem
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class ConfirmPasswordViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    private let compareCurrentPassswordUseCase: CompareCurrentPassswordUseCase

    public init(compareCurrentPassswordUseCase: CompareCurrentPassswordUseCase) {
        self.compareCurrentPassswordUseCase = compareCurrentPassswordUseCase
    }

    public struct Input {
        let currentPassword: Driver<String>
        let nextButtonDidTap: Signal<Void>
    }

    public struct Output {
        let passwordErrorDescription: PublishRelay<DescriptionType>
        let nextButtonIsEnable: PublishRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let passwordErrorDescription = PublishRelay<DescriptionType>()
        let nextButtonIsEnable = PublishRelay<Bool>()

        input.nextButtonDidTap.asObservable()
            .withLatestFrom(input.currentPassword)
            .flatMap { currentPassword in
                self.compareCurrentPassswordUseCase.execute(password: currentPassword)
                    .andThen(Single.just(
                        ConfirmPasswordStep.changePasswordIsRequired(
                            currentPassword: currentPassword
                        )
                    ))
                    .catch { _ in
                        passwordErrorDescription.accept(.error(description: "비밀번호가 옳지 않아요"))
                        return .never()
                    }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.currentPassword.asObservable()
            .distinctUntilChanged()
            .map { !$0.isEmpty }
            .bind(to: nextButtonIsEnable)
            .disposed(by: disposeBag)

        return Output(
            passwordErrorDescription: passwordErrorDescription,
            nextButtonIsEnable: nextButtonIsEnable
        )
    }
}
