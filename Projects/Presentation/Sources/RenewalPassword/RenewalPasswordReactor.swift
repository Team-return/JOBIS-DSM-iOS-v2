import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain
import DesignSystem

public final class RenewalPasswordReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let renewalPasswordUseCase: RenewalPasswordUseCase

    public init(
        renewalPasswordUseCase: RenewalPasswordUseCase,
        email: String
    ) {
        self.initialState = .init(email: email)
        self.renewalPasswordUseCase = renewalPasswordUseCase
    }

    public enum Action {
        case updateNewPassword(String)
        case updateCheckNewPassword(String)
        case changePasswordButtonDidTap
    }

    public enum Mutation {
        case setNewPassword(String)
        case setCheckNewPassword(String)
        case setPasswordError(DescriptionType?)
        case setCheckPasswordError(DescriptionType?)
        case setButtonEnabled(Bool)
    }

    public struct State {
        let email: String
        var newPassword: String = ""
        var checkNewPassword: String = ""
        var passwordError: DescriptionType?
        var checkPasswordError: DescriptionType?
        var isButtonEnabled: Bool = false
    }
}

extension RenewalPasswordReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateNewPassword(password):
            return .concat([
                .just(.setNewPassword(password)),
                .just(.setPasswordError(nil)),
                .just(.setButtonEnabled(!password.isEmpty && !currentState.checkNewPassword.isEmpty))
            ])

        case let .updateCheckNewPassword(password):
            return .concat([
                .just(.setCheckNewPassword(password)),
                .just(.setCheckPasswordError(nil)),
                .just(.setButtonEnabled(!currentState.newPassword.isEmpty && !password.isEmpty))
            ])

        case .changePasswordButtonDidTap:
            let passwordExpression =
            #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$"#

            if !(currentState.newPassword ~= passwordExpression) {
                return .concat([
                    .just(.setPasswordError(.error(description: "비밀번호 형식에 맞지 않아요."))),
                    .just(.setButtonEnabled(false))
                ])
            }

            if currentState.newPassword != currentState.checkNewPassword {
                return .concat([
                    .just(.setCheckPasswordError(.error(description: "비밀번호가 동일하지 않아요."))),
                    .just(.setButtonEnabled(false))
                ])
            }

            return renewalPasswordUseCase.execute(
                req: .init(email: currentState.email.dsmEmail(), password: currentState.newPassword)
            )
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.steps.accept(RenewalPasswordStep.tabsIsRequired)
            })
            .flatMap { _ in Observable<Mutation>.empty() }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setNewPassword(password):
            newState.newPassword = password

        case let .setCheckNewPassword(password):
            newState.checkNewPassword = password

        case let .setPasswordError(error):
            newState.passwordError = error

        case let .setCheckPasswordError(error):
            newState.checkPasswordError = error

        case let .setButtonEnabled(isEnabled):
            newState.isButtonEnabled = isEnabled
        }
        return newState
    }
}
