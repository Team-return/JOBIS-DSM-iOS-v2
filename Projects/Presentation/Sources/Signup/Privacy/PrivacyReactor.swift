import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain
import FirebaseMessaging
import Utility
import ReactorKit

public final class PrivacyReactor: BaseReactor, Reactor {
    public enum Action {
        case enableSignupButton
        case signupButtonDidTap
    }

    public enum Mutation {
        case setSignupButtonEnabled(Bool)
        case setSignupError(String?)
    }

    public struct State {
        public let name: String
        public let gcn: Int
        public let email: String
        public let password: String
        public let isMan: Bool
        public let profileImageURL: String?
        public var isSignupButtonEnabled: Bool = false
        public var signupError: String?
    }

    public var initialState: State
    public let steps = PublishRelay<Step>()
    private let signupUseCase: SignupUseCase

    public init(
        name: String,
        gcn: Int,
        email: String,
        password: String,
        isMan: Bool,
        profileImageURL: String?,
        signupUseCase: SignupUseCase
    ) {
        self.signupUseCase = signupUseCase
        self.initialState = State(
            name: name,
            gcn: gcn,
            email: email,
            password: password,
            isMan: isMan,
            profileImageURL: profileImageURL
        )
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .enableSignupButton:
            return .just(.setSignupButtonEnabled(true))

        case .signupButtonDidTap:
            let name = currentState.name
            let gcn = currentState.gcn
            let email = currentState.email
            let password = currentState.password
            let isMan = currentState.isMan
            let profileImageURL = currentState.profileImageURL

            return .concat([
                .just(.setSignupError(nil)),
                signupUseCase.execute(
                    req: .init(
                        email: email.dsmEmail(),
                        password: password,
                        grade: gcn.extract(4),
                        name: name,
                        gender: isMan ? .man : .woman,
                        classRoom: gcn.extract(3),
                        number: gcn % 100,
                        deviceToken: Messaging.messaging().fcmToken,
                        profileImageURL: profileImageURL
                    )
                )
                .asObservable()
                .do(onNext: { [weak self] _ in
                    self?.steps.accept(PrivacyStep.tabsIsRequired)
                })
                .flatMap { _ in Observable<Mutation>.empty() }
                .catch { error in
                    if let appError = error as? ApplicationsError {
                        switch appError {
                        case .conflict:
                            return .just(.setSignupError("이미 가입된 계정이에요."))

                        case .badRequest:
                            return .just(.setSignupError("입력 정보를 확인해주세요."))

                        case .internalServerError:
                            return .just(.setSignupError("서버 오류가 발생했어요."))
                        }
                    }
                    return .just(.setSignupError("회원가입에 실패했어요. 다시 시도해주세요."))
                }
            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setSignupButtonEnabled(isEnabled):
            newState.isSignupButtonEnabled = isEnabled

        case let .setSignupError(error):
            newState.signupError = error
        }

        return newState
    }
}
