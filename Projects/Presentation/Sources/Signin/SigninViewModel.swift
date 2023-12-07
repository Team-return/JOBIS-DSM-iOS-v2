import Core
import Domain
import RxFlow
import RxSwift
import RxCocoa
import DesignSystem

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
        let emailErrorDescription: PublishRelay<DescriptionType>
        let passwordErrorDescription: PublishRelay<DescriptionType>
    }

    public func transform(_ input: Input) -> Output {
        let emailErrorDescription = PublishRelay<DescriptionType>()
        let passwordErrorDescription = PublishRelay<DescriptionType>()

        let info = Driver.combineLatest(input.email, input.password)
        input.signinButtonDidTap
            .asObservable()
            .withLatestFrom(info)
            .filter { email, password in
                if email.isEmpty {
                    emailErrorDescription.accept(.error(description: "빈칸을 채워주세요"))
                    return false
                } else if password.isEmpty {
                    passwordErrorDescription.accept(.error(description: "빈칸을 채워주세요"))
                    return false
                }
                return true
            }
            .flatMap { [self] email, password in
                return signinUseCase.execute(
                    req: .init(
                        accountID: email.dsmEmail(),
                        password: password
                    )
                )
                .filter { $0 == .developer || $0 == .student}
                .catch { error in
                    guard let error = error as? UsersError else { return .never() }
                    switch error {
                    case .notFoundPassword:
                        passwordErrorDescription.accept(.error(description: "비밀번호가 옳지 않아요"))
                    case .notFoundEmail:
                        emailErrorDescription.accept(.error(description: "아이디를 찾지 못했어요"))
                    case .internalServerError:
                        emailErrorDescription.accept(.error(description: error.localizedDescription))
                    }
                    return .never()
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
