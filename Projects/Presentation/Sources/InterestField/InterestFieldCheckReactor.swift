import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class InterestFieldCheckReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase

    public init(fetchStudentInfoUseCase: FetchStudentInfoUseCase) {
        self.initialState = .init()
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
    }

    public enum Action {
        case fetchStudentInfo
    }

    public enum Mutation {
        case setStudentName(String)
    }

    public struct State {
        var studentName: String = ""
    }
}

extension InterestFieldCheckReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchStudentInfo:
            return fetchStudentInfoUseCase.execute()
                .asObservable()
                .map { .setStudentName($0.studentName) }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setStudentName(name):
            newState.studentName = name
        }

        return newState
    }
}
