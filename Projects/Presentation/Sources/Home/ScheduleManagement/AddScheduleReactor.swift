import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core

public final class AddScheduleReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State = .init()

    public struct State {}

    public enum Action {
        case backButtonDidTap
    }

    public enum Mutation {}

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonDidTap:
            steps.accept(ScheduleStep.scheduleIsRequired)
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
