import ReactorKit
import RxSwift
import RxCocoa
import RxFlow

public final class WinterInternOffSeasonReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State

    public init() {
        self.initialState = .init()
    }

    public enum Action {
        case viewDidLoad
    }

    public enum Mutation {
        case none
    }

    public struct State {
    }
}

extension WinterInternOffSeasonReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .none:
            return state
        }
    }
}
