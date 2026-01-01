import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain
import Utility
import ReactorKit

public final class VerifyEmailReactor: BaseReactor, Reactor {
    public enum Action {
        case updateEmail(String)
        case updateAuthCode(String)
        case sendAuthCodeButtonDidTap
        case nextButtonDidTap
    }

    public enum Mutation {
        case setEmail(String)
        case setAuthCode(String)
        case setEmailError(DescriptionType?)
        case setAuthCodeError(DescriptionType?)
        case setIsSuccessedToSendAuthCode(Bool)
    }

    public struct State {
        public let name: String
        public let gcn: Int
        public var email: String = ""
        public var authCode: String = ""
        public var emailErrorDescription: DescriptionType?
        public var authCodeErrorDescription: DescriptionType?
        public var isSuccessedToSendAuthCode: Bool = false
    }

    public var initialState: State
    public let steps = PublishRelay<Step>()
    private let sendAuthCodeUseCase: SendAuthCodeUseCase
    private let verifyAuthCodeUseCase: VerifyAuthCodeUseCase

    public init(
        name: String,
        gcn: Int,
        sendAuthCodeUseCase: SendAuthCodeUseCase,
        verifyAuthCodeUseCase: VerifyAuthCodeUseCase
    ) {
        self.sendAuthCodeUseCase = sendAuthCodeUseCase
        self.verifyAuthCodeUseCase = verifyAuthCodeUseCase
        self.initialState = State(name: name, gcn: gcn)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateEmail(email):
            return .just(.setEmail(email))

        case let .updateAuthCode(authCode):
            return .just(.setAuthCode(authCode))

        case .sendAuthCodeButtonDidTap:
            let email = currentState.email

            if email.isEmpty {
                return .just(.setEmailError(.error(description: "이메일은 공백일 수 없어요.")))
            }

            return .concat([
                .just(.setEmailError(nil)),
                sendAuthCodeUseCase.execute(req: .init(email: email.dsmEmail(), authCodeType: .signup))
                    .andThen(Observable.just(Mutation.setIsSuccessedToSendAuthCode(true)))
                    .catch { _ in
                        return .just(.setEmailError(.error(description: "이미 가입 된 이메일이에요.")))
                    }
            ])

        case .nextButtonDidTap:
            let email = currentState.email
            let authCode = currentState.authCode
            let name = currentState.name
            let gcn = currentState.gcn

            return .concat([
                .just(.setEmailError(nil)),
                .just(.setAuthCodeError(nil)),
                verifyAuthCodeUseCase.execute(email: email.dsmEmail(), authCode: authCode)
                    .andThen(Observable<Mutation>.empty())
                    .do(onCompleted: { [weak self] in
                        self?.steps.accept(VerifyEmailStep.passwordSettingIsRequired(name: name, gcn: gcn, email: email))
                    })
                    .catch { _ in
                        return .just(.setAuthCodeError(.error(description: "인증코드가 잘못되었어요.")))
                    }
            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setEmail(email):
            newState.email = email

        case let .setAuthCode(authCode):
            newState.authCode = authCode

        case let .setEmailError(error):
            newState.emailErrorDescription = error

        case let .setAuthCodeError(error):
            newState.authCodeErrorDescription = error

        case let .setIsSuccessedToSendAuthCode(isSuccessed):
            newState.isSuccessedToSendAuthCode = isSuccessed
        }

        return newState
    }
}
