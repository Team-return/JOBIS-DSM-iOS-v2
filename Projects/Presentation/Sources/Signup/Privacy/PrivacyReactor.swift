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
        case navigateToTabs
    }

    public struct State {
        public let name: String
        public let gcn: Int
        public let email: String
        public let password: String
        public let isMan: Bool
        public let profileImageURL: String?
        public var isSignupButtonEnabled: Bool = false
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

            return signupUseCase.execute(
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
            .catch { _ in .never() }
            .andThen(Observable<Mutation>.just(.navigateToTabs))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setSignupButtonEnabled(isEnabled):
            newState.isSignupButtonEnabled = isEnabled

        case .navigateToTabs:
            steps.accept(PrivacyStep.tabsIsRequired)
        }

        return newState
    }
}
