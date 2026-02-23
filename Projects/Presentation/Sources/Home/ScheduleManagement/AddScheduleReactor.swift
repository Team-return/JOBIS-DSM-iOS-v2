import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core

public final class AddScheduleReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State = .init()

    public enum Action {
        case backButtonDidTap
        case companyChanged(String)
        case typeChanged(String)
        case locationChanged(String)
        case singleDateChanged(String)
        case startDateChanged(String)
        case endDateChanged(String)
        case timeChanged(String)
        case periodToggled(Bool)
    }

    public enum Mutation {
        case setCompany(String)
        case setType(String)
        case setLocation(String)
        case setSingleDate(String)
        case setStartDate(String)
        case setEndDate(String)
        case setTime(String)
        case setIsPeriod(Bool)
    }

    public struct State {
        var company: String = ""
        var type: String = ""
        var location: String = ""
        var singleDate: String = ""
        var startDate: String = ""
        var endDate: String = ""
        var time: String = ""
        var isPeriod: Bool = false
        var isAddButtonEnabled: Bool = false
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonDidTap:
            steps.accept(ScheduleStep.scheduleIsRequired)
            return .empty()
        case let .companyChanged(value): return .just(.setCompany(value))
        case let .typeChanged(value): return .just(.setType(value))
        case let .locationChanged(value): return .just(.setLocation(value))
        case let .singleDateChanged(value): return .just(.setSingleDate(value))
        case let .startDateChanged(value): return .just(.setStartDate(value))
        case let .endDateChanged(value): return .just(.setEndDate(value))
        case let .timeChanged(value): return .just(.setTime(value))
        case let .periodToggled(isPeriod): return .just(.setIsPeriod(isPeriod))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setCompany(ver): newState.company = ver
        case let .setType(ver): newState.type = ver
        case let .setLocation(ver): newState.location = ver
        case let .setSingleDate(ver): newState.singleDate = ver
        case let .setStartDate(ver): newState.startDate = ver
        case let .setEndDate(ver): newState.endDate = ver
        case let .setTime(ver): newState.time = ver
        case let .setIsPeriod(ver): newState.isPeriod = ver
        }
        let base = !newState.company.isEmpty && !newState.type.isEmpty
            && !newState.location.isEmpty && !newState.time.isEmpty
        newState.isAddButtonEnabled = newState.isPeriod
            ? base && !newState.startDate.isEmpty && !newState.endDate.isEmpty
            : base && !newState.singleDate.isEmpty
        return newState
    }
}
