import Core
import Domain
import RxFlow
import RxSwift
import RxCocoa
import Utility
import ReactorKit

public final class GenderSettingReactor: BaseReactor, Reactor {
    public enum Action {
        case selectGender(GenderType)
        case nextButtonDidTap
    }

    public enum Mutation {
        case setGender(GenderType)
    }

    public struct State {
        public let name: String
        public let gcn: Int
        public let email: String
        public let password: String
        public var gender: GenderType?
        public var isNextButtonEnabled: Bool = false
    }

    public var initialState: State
    public let steps = PublishRelay<Step>()

    public init(
        name: String,
        gcn: Int,
        email: String,
        password: String
    ) {
        self.initialState = State(name: name, gcn: gcn, email: email, password: password)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectGender(gender):
            return .just(.setGender(gender))

        case .nextButtonDidTap:
            guard let gender = currentState.gender else {
                return .empty()
            }

            let name = currentState.name
            let gcn = currentState.gcn
            let email = currentState.email
            let password = currentState.password
            let isMan = gender == .man

            steps.accept(GenderSettingStep.profileSettingIsRequired(
                name: name,
                gcn: gcn,
                email: email,
                password: password,
                isMan: isMan
            ))

            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setGender(gender):
            newState.gender = gender
            newState.isNextButtonEnabled = true
        }

        return newState
    }
}
