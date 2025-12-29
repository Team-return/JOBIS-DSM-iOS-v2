import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core

public final class EmploymentFilterReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State

    public init() {
        self.initialState = .init()
    }

    public enum Action {
        case viewWillAppear
        case applyButtonDidTap(Int)
    }

    public enum Mutation {
    }

    public struct State {
        var currentYear: Int = Calendar.current.component(.year, from: Date())
    }
}

extension EmploymentFilterReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .empty()

        case let .applyButtonDidTap(year):
            steps.accept(EmployStatusStep.applyYearFilter(year: year))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}
