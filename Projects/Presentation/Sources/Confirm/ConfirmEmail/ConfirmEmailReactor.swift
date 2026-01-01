import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain
import DesignSystem

public final class ConfirmEmailReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let sendAuthCodeUseCase: SendAuthCodeUseCase
    private let verifyAuthCodeUseCase: VerifyAuthCodeUseCase

    public init(
        sendAuthCodeUseCase: SendAuthCodeUseCase,
        verifyAuthCodeUseCase: VerifyAuthCodeUseCase
    ) {
        self.initialState = .init()
        self.sendAuthCodeUseCase = sendAuthCodeUseCase
        self.verifyAuthCodeUseCase = verifyAuthCodeUseCase
    }

    public enum Action {
        case updateEmail(String)
        case updateAuthCode(String)
        case sendAuthCodeButtonDidTap
        case nextButtonDidTap
    }

    public enum Mutation {
        case setEmail(String)
        case setAuthCode(String)
        case setEmailError(String)
        case setAuthCodeError(String)
        case setSendAuthCodeSuccess(Bool)
        case resetErrors
    }

    public struct State {
        var email: String = ""
        var authCode: String = ""
        var emailError: String = ""
        var authCodeError: String = ""
        var isSendAuthCodeSuccess: Bool = false
    }
}

extension ConfirmEmailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateEmail(email):
            return .just(.setEmail(email))

        case let .updateAuthCode(authCode):
            return .just(.setAuthCode(authCode))

        case .sendAuthCodeButtonDidTap:
            guard !currentState.email.isEmpty else {
                return .just(.setEmailError("이메일은 공백일 수 없어요."))
            }

            return sendAuthCodeUseCase.execute(
                req: .init(
                    email: currentState.email.dsmEmail(),
                    authCodeType: .password
                )
            )
            .andThen(Observable<Mutation>.just(.setSendAuthCodeSuccess(true)))
            .catch { _ in
                .just(.setEmailError("이미 가입 된 이메일이에요."))
            }

        case .nextButtonDidTap:
            return verifyAuthCodeUseCase.execute(
                email: currentState.email.dsmEmail(),
                authCode: currentState.authCode
            )
            .andThen(Observable<Mutation>.empty())
            .do(onCompleted: { [weak self] in
                guard let email = self?.currentState.email else { return }
                self?.steps.accept(ConfirmEmailStep.renewalPasswordIsRequired(email: email))
            })
            .catch { _ in
                .just(.setEmailError("인증코드가 잘못되었어요."))
            }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setEmail(email):
            newState.email = email
            newState.emailError = ""

        case let .setAuthCode(authCode):
            newState.authCode = authCode
            newState.authCodeError = ""

        case let .setEmailError(error):
            newState.emailError = error

        case let .setAuthCodeError(error):
            newState.authCodeError = error

        case let .setSendAuthCodeSuccess(success):
            newState.isSendAuthCodeSuccess = success

        case .resetErrors:
            newState.emailError = ""
            newState.authCodeError = ""
        }

        return newState
    }
}

private extension String {
    func dsmEmail() -> String {
        return "\(self)@dsm.hs.kr"
    }
}
