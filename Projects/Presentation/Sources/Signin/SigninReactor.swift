import ReactorKit
import RxSwift
import RxCocoa
import Domain
import RxFlow
import Core

public final class SigninReactor: BaseReactor, Stepper {
    public var steps = PublishRelay<Step>()
    private let signinUseCase: SigninUseCase
    public let initialState: State
    private let disposeBag = DisposeBag()

    init(signinUseCase: SigninUseCase) {
        self.initialState = .init()
        self.signinUseCase = signinUseCase
    }
    public enum Action {
        case updateEmail(String)
        case updatePassword(String)
        case signinButtonDidTap
    }

    public enum Mutation {
        case updateEmail(String)
        case updatePassword(String)
        case emailError(String)
        case passwordError(String)
        case errorReset
        case signinSuccess
    }

    public struct State {
        var email: String = ""
        var password: String = ""
        var emailError: String = ""
        var passwordError: String = ""
    }

}

extension SigninReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .signinButtonDidTap:
            return signinButtonDidTap(email: self.currentState.email, password: self.currentState.password)
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        case let .updatePassword(password):
            return .just(.updatePassword(password))
        }
    }
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateEmail(email):
            newState.email = email
        case let .updatePassword(password):
            newState.password = password
        case let .emailError(error):
            newState.emailError = error
        case let .passwordError(error):
            newState.passwordError = error
        case .errorReset:
            newState.emailError = ""
            newState.passwordError = ""
        case .signinSuccess:
            steps.accept(SigninStep.tabsIsRequired)
        }
        return newState
    }
    func signinButtonDidTap(email: String, password: String) -> Observable<Mutation> {
        if email.isEmpty {
            return Observable.concat([
                .just(.emailError("빈칸을 채워주세요")),
                .just(.errorReset)
            ])
        } else if password.isEmpty {
            return Observable.concat([
                .just(.passwordError("빈칸을 채워주세요")),
                .just(.errorReset)
            ])
        } else {
            return self.signinUseCase.execute(req: .init(accountID: "\(email)@dsm.hs.kr", password: password))
                .asObservable()
                .map { _ in Mutation.signinSuccess }
//                .catch { error in
//                    guard let error = error as? UsersError else { return .never() }
//                    switch error {
//                    case .notFoundPassword:
//                        return .concat([
//                            .just(.passwordError("비밀번호가 옳지 않아요")),
//                            .just(.errorReset)
//                        ])
//                    case .notFoundEmail:
//                        return .concat([
//                            .just(.emailError("아이디를 찾지 못했어요")),
//                            .just(.errorReset)
//                        ])
//                    case .internalServerError:
//                        return .just(.emailError(error.localizedDescription))
//                    }
//                }
        }
    }
}
