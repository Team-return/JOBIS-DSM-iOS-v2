import Core
import DesignSystem
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class ConfirmEmailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let sendAuthCodeUseCase: SendAuthCodeUseCase
    private let verifyAuthCodeUseCase: VerifyAuthCodeUseCase

    init(
        sendAuthCodeUseCase: SendAuthCodeUseCase,
        verifyAuthCodeUseCase: VerifyAuthCodeUseCase
    ) {
        self.sendAuthCodeUseCase = sendAuthCodeUseCase
        self.verifyAuthCodeUseCase = verifyAuthCodeUseCase
    }

    public struct Input {
        let email: Driver<String>
        let authCode: Driver<String>
        let sendAuthCodeButtonDidTap: Signal<Void>
        let nextButtonDidTap: Signal<Void>
    }

    public struct Output {
        let emailErrorDescription: PublishRelay<DescriptionType>
        let authCodeErrorDescription: PublishRelay<DescriptionType>
        let isSuccessedToSendAuthCode: BehaviorRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let emailErrorDescription = PublishRelay<DescriptionType>()
        let authCodeErrorDescription = PublishRelay<DescriptionType>()
        let isSuccessedToSendAuthCode = BehaviorRelay(value: false)
        let info = Driver.combineLatest(input.email, input.authCode)

        input.sendAuthCodeButtonDidTap
            .asObservable()
            .withLatestFrom(input.email)
            .filter {
                if $0.isEmpty {
                    emailErrorDescription.accept(.error(description: "이메일은 공백일 수 없어요."))
                    return false
                }
                return true
            }
            .flatMap { [self] email in
                sendAuthCodeUseCase.execute(req: .init(email: email.dsmEmail(), authCodeType: .password))
                    .catch { _ in
                        emailErrorDescription.accept(.error(description: "이미 가입 된 이메일이에요."))
                        return .never()
                    }
                    .andThen(Single.just(true))
            }
            .bind(to: isSuccessedToSendAuthCode)
            .disposed(by: disposeBag)

        input.nextButtonDidTap
            .asObservable()
            .withLatestFrom(info)
            .flatMap { [self] email, authCode in
                verifyAuthCodeUseCase.execute(email: email.dsmEmail(), authCode: authCode)
                    .catch { _ in
                        emailErrorDescription.accept(.error(description: "인증코드가 잘못되었어요."))
                        return .never()
                    }
                    .andThen(
                        Single.just(
                            ConfirmEmailStep.renewalPasswordIsRequired(email: email)
                        )
                    )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            emailErrorDescription: emailErrorDescription,
            authCodeErrorDescription: authCodeErrorDescription,
            isSuccessedToSendAuthCode: isSuccessedToSendAuthCode
        )
    }
}
