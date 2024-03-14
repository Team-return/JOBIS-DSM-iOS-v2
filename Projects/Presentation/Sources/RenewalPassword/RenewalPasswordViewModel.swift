import Core
import DesignSystem
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class RenewalPasswordViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    private let renewalPasswordUseCase: RenewalPasswordUseCase

    public init(renewalPasswordUseCase: RenewalPasswordUseCase) {
        self.renewalPasswordUseCase = renewalPasswordUseCase
    }

    public struct Input {
        let email: String
        let newPassword: Driver<String>
        let checkNewPassword: Driver<String>
        let changePasswordButtonDidTap: Signal<Void>
    }
    public struct Output {
        let passwordErrorDescription: PublishRelay<DescriptionType>
        let checkingPasswordErrorDescription: PublishRelay<DescriptionType>
        let changePasswordButtonIsEnable: PublishRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let passwordErrorDescription = PublishRelay<DescriptionType>()
        let checkingPasswordErrorDescription = PublishRelay<DescriptionType>()
        let changePasswordButtonIsEnable = PublishRelay<Bool>()
        let info = Driver.combineLatest(input.newPassword, input.checkNewPassword)

        input.changePasswordButtonDidTap.asObservable()
            .withLatestFrom(info)
            .filter { password, checkingPassword in
                let passwordExpression =
                #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$"#
                if !(password ~= passwordExpression) {
                    passwordErrorDescription.accept(.error(description: "비밀번호 형식에 맞지 않아요."))
                    return false
                } else if password != checkingPassword {
                    checkingPasswordErrorDescription.accept(
                        .error(description: "비밀번호가 동일하지 않아요.")
                    )
                }
                return true
            }
            .flatMap { newPassword, _ in
                self.renewalPasswordUseCase.execute(
                    req: .init(email: input.email.dsmEmail(), password: newPassword)
                )
                .andThen(Single.just(
                    RenewalPasswordStep.tabsIsRequired
                ))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        Driver.combineLatest(input.newPassword, input.checkNewPassword)
            .asObservable()
            .map { new, check in
                !new.isEmpty && !check.isEmpty
            }
            .bind(to: changePasswordButtonIsEnable)
            .disposed(by: disposeBag)

        return Output(
            passwordErrorDescription: passwordErrorDescription,
            checkingPasswordErrorDescription: checkingPasswordErrorDescription,
            changePasswordButtonIsEnable: changePasswordButtonIsEnable
        )
    }
}
