import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain
import Utility

public final class PasswordSettingViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public struct Input {
        let name: String
        let gcn: Int
        let email: String
        let password: Driver<String>
        let checkingPassword: Driver<String>
        let nextButtonDidTap: Signal<Void>
    }

    public struct Output {
        let passwordErrorDescription: PublishRelay<DescriptionType>
        let checkingPasswordErrorDescription: PublishRelay<DescriptionType>
    }

    public func transform(_ input: Input) -> Output {
        let passwordErrorDescription = PublishRelay<DescriptionType>()
        let checkingPasswordErrorDescription = PublishRelay<DescriptionType>()
        let info = Driver.combineLatest(input.password, input.checkingPassword)

        input.nextButtonDidTap.asObservable()
            .withLatestFrom(info)
            .avoidDuplication
            .filter { password, checkingPassword in
                let passwordExpression =
                #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$"#
                if password.isEmpty {
                    passwordErrorDescription.accept(.error(description: "빈칸을 채워주세요"))
                    return false
                } else if checkingPassword.isEmpty {
                    checkingPasswordErrorDescription.accept(.error(description: "빈칸을 채워주세요"))
                    return false
                } else if !(password ~= passwordExpression) {
                    passwordErrorDescription.accept(.error(description: "비밀번호 형식에 맞지 않아요."))
                    return false
                } else if password != checkingPassword {
                    checkingPasswordErrorDescription.accept(.error(description: "비밀번호가 동일하지 않아요."))
                    return false
                }
                return true
            }
            .map { password, _ in
                PasswordSettingStep.genderSettingIsRequired(
                    name: input.name,
                    gcn: input.gcn,
                    email: input.email,
                    password: password
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            passwordErrorDescription: passwordErrorDescription,
            checkingPasswordErrorDescription: checkingPasswordErrorDescription
        )
    }
}
