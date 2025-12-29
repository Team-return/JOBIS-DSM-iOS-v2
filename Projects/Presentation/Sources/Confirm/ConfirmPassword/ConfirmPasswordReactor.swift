import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain
import DesignSystem

public final class ConfirmPasswordReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let compareCurrentPassswordUseCase: CompareCurrentPassswordUseCase

    init(compareCurrentPassswordUseCase: CompareCurrentPassswordUseCase) {
        self.initialState = .init()
        self.compareCurrentPassswordUseCase = compareCurrentPassswordUseCase
    }

    public enum Action {
        case updatePassword(String)
        case nextButtonDidTap
    }

    public enum Mutation {
        case setPassword(String)
        case setPasswordError(String)
    }

    public struct State {
        var currentPassword: String = ""
        var passwordError: String = ""
        var isNextButtonEnabled: Bool = false

        mutating func updatePassword(_ password: String) {
            self.currentPassword = password
            self.passwordError = ""
            self.isNextButtonEnabled = !password.isEmpty
        }
    }
}

extension ConfirmPasswordReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updatePassword(password):
            return .just(.setPassword(password))

        case .nextButtonDidTap:
            return compareCurrentPassswordUseCase.execute(password: currentState.currentPassword)
                .andThen(Observable<Mutation>.empty())
                .do(onCompleted: { [weak self] in
                    guard let password = self?.currentState.currentPassword else { return }
                    self?.steps.accept(
                        ConfirmPasswordStep.changePasswordIsRequired(currentPassword: password)
                    )
                })
                .catch { _ in
                    .just(.setPasswordError("비밀번호가 옳지 않아요"))
                }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setPassword(password):
            newState.updatePassword(password)

        case let .setPasswordError(error):
            newState.passwordError = error
        }

        return newState
    }
}
