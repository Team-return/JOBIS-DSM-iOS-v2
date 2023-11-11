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
        let emailErrorDescription: PublishRelay<String>
        let passwordErrorDescription: PublishRelay<String>

        let info = Driver.combineLatest(input.email, input.password)
        input.signinButtonDidTap.asObservable()
            .withLatestFrom(info)
            .flatMap { email, password in
                self.signinUseCase.execute(req: .init(accountID: email, password: password))
                    .asObservable()
                    .filter { $0 == .developer || $0 == .student }
                    .
            }
            .subscribe(onNext: { _ in
                Single.just(SigninStep.mainIsRequired)
            }, onError: { error in
                guard let error = error as? UsersError else { return }
                switch error {
                case .notFoundPassword:
                    passwordErrorDescription.accept(error.localizedDescription)
                case .notFoundEmail, .internalServerError:
                    emailErrorDescription.accept(error.localizedDescription)
                }
            })
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output(emailErrorDescription: emailErrorDescription, passwordErrorDescription: passwordErrorDescription)
    }
}
