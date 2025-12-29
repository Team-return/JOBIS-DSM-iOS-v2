import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain
import Utility
import ReactorKit

public final class PasswordSettingReactor: BaseReactor, Reactor {
    public enum Action {
        case updatePassword(String)
        case updateCheckingPassword(String)
        case nextButtonDidTap
    }

    public enum Mutation {
        case setPassword(String)
        case setCheckingPassword(String)
        case setPasswordError(DescriptionType?)
        case setCheckingPasswordError(DescriptionType?)
    }

    public struct State {
        public let name: String
        public let gcn: Int
        public let email: String
        public var password: String = ""
        public var checkingPassword: String = ""
        public var passwordErrorDescription: DescriptionType?
        public var checkingPasswordErrorDescription: DescriptionType?
    }

    public var initialState: State
    public let steps = PublishRelay<Step>()

    public init(
        name: String,
        gcn: Int,
        email: String
    ) {
        self.initialState = State(name: name, gcn: gcn, email: email)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updatePassword(password):
            return .just(.setPassword(password))

        case let .updateCheckingPassword(checkingPassword):
            return .just(.setCheckingPassword(checkingPassword))

        case .nextButtonDidTap:
            let password = currentState.password
            let checkingPassword = currentState.checkingPassword
            let name = currentState.name
            let gcn = currentState.gcn
            let email = currentState.email

            let passwordExpression =
            #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$"#

            if password.isEmpty {
                return .just(.setPasswordError(.error(description: "빈칸을 채워주세요")))
            } else if checkingPassword.isEmpty {
                return .just(.setCheckingPasswordError(.error(description: "빈칸을 채워주세요")))
            } else if !(password ~= passwordExpression) {
                return .just(.setPasswordError(.error(description: "비밀번호 형식에 맞지 않아요.")))
            } else if password != checkingPassword {
                return .just(.setCheckingPasswordError(.error(description: "비밀번호가 동일하지 않아요.")))
            }

            steps.accept(PasswordSettingStep.genderSettingIsRequired(
                name: name,
                gcn: gcn,
                email: email,
                password: password
            ))

            return .concat([
                .just(.setPasswordError(nil)),
                .just(.setCheckingPasswordError(nil))
            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setPassword(password):
            newState.password = password

        case let .setCheckingPassword(checkingPassword):
            newState.checkingPassword = checkingPassword

        case let .setPasswordError(error):
            newState.passwordErrorDescription = error

        case let .setCheckingPasswordError(error):
            newState.checkingPasswordErrorDescription = error
        }

        return newState
    }
}
