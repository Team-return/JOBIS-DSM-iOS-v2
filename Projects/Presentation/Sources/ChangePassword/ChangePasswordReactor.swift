import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain
import DesignSystem

public final class ChangePasswordReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let changePasswordUseCase: ChangePasswordUseCase

    public init(
        changePasswordUseCase: ChangePasswordUseCase,
        currentPassword: String = ""
    ) {
        self.changePasswordUseCase = changePasswordUseCase
        self.initialState = .init(currentPassword: currentPassword)
    }

    public enum Action {
        case updateNewPassword(String)
        case updateCheckNewPassword(String)
        case changePasswordButtonDidTap
    }

    public enum Mutation {
        case setNewPassword(String)
        case setCheckNewPassword(String)
        case setPasswordErrorDescription(DescriptionType?)
        case setCheckingPasswordErrorDescription(DescriptionType?)
    }

    public struct State {
        var currentPassword: String
        var newPassword: String = ""
        var checkNewPassword: String = ""
        var passwordErrorDescription: DescriptionType?
        var checkingPasswordErrorDescription: DescriptionType?
        var changePasswordButtonIsEnable: Bool = false
    }
}

extension ChangePasswordReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateNewPassword(password):
            return .just(.setNewPassword(password))

        case let .updateCheckNewPassword(password):
            return .just(.setCheckNewPassword(password))

        case .changePasswordButtonDidTap:
            let password = currentState.newPassword
            let checkingPassword = currentState.checkNewPassword
            let passwordExpression =
                #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$"#

            if !(password ~= passwordExpression) {
                return .just(.setPasswordErrorDescription(
                    .error(description: "비밀번호 형식에 맞지 않아요.")
                ))
            } else if password != checkingPassword {
                return .just(.setCheckingPasswordErrorDescription(
                    .error(description: "비밀번호가 동일하지 않아요.")
                ))
            }

            return changePasswordUseCase.execute(
                req: .init(
                    currentPassword: currentState.currentPassword,
                    newPassword: password
                )
            )
            .do(onCompleted: { [weak self] in
                self?.steps.accept(ChangePasswordStep.tabsIsRequired)
            })
            .andThen(Observable<Mutation>.empty())
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setNewPassword(password):
            newState.newPassword = password
            newState.changePasswordButtonIsEnable = !password.isEmpty && !state.checkNewPassword.isEmpty
            newState.passwordErrorDescription = nil

        case let .setCheckNewPassword(password):
            newState.checkNewPassword = password
            newState.changePasswordButtonIsEnable = !state.newPassword.isEmpty && !password.isEmpty
            newState.checkingPasswordErrorDescription = nil

        case let .setPasswordErrorDescription(description):
            newState.passwordErrorDescription = description

        case let .setCheckingPasswordErrorDescription(description):
            newState.checkingPasswordErrorDescription = description
        }
        return newState
    }
}
