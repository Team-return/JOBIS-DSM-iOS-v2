import Core
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class SigninViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let signinUseCase: SigninUseCase

    init(signinUseCase: SigninUseCase) {
        self.signinUseCase = signinUseCase
    }

    private let disposeBag = DisposeBag()
    public struct Input {
        let email: Driver<String>
        let password: Driver<String>
        let signinButtonDidTap: Signal<Void>
    }
    public struct Output {
        let emailErrorDescription: PublishRelay<String>
        let passwordErrorDescription: PublishRelay<String>
    }

    public func transform(_ input: Input) -> Output {
        let emailErrorDescription = PublishRelay<String>()
        let passwordErrorDescription = PublishRelay<String>()

        let info = Driver.combineLatest(input.email, input.password)
        input.signinButtonDidTap
            .asObservable()
            .withLatestFrom(info)
            .filter { email, password in
                if email.isEmpty {
                    emailErrorDescription.accept("이메일은 공백일 수 없습니다.")
                    return false
                } else if password.isEmpty {
                    passwordErrorDescription.accept("비밀번호는 공백일 수 없습니다.")
                    return false
                }
                return true
            }
            .flatMap { [self] email, password in
                return signinUseCase.execute(
                    req: .init(
                        accountID: email + "@dsm.hs.kr",
                        password: password
                    )
                )
                .filter { $0 == .developer || $0 == .student}
                .catch { error in
                    guard let error = error as? UsersError else { return .empty() }
                    switch error {
                    case .notFoundPassword:
                        passwordErrorDescription.accept("비밀번호가 올바르지 않습니다.")
                    case .notFoundEmail:
                        emailErrorDescription.accept("이메일이 찾을 수 없습니다.")
                    case .internalServerError:
                        emailErrorDescription.accept(error.localizedDescription)
                    }
                    return .empty()
                }
            }
            .map { _ in SigninStep.tabsIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            emailErrorDescription: emailErrorDescription,
            passwordErrorDescription: passwordErrorDescription
        )
    }
}
