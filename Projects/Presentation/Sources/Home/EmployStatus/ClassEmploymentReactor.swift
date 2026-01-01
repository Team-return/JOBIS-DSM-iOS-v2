import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ClassEmploymentReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchEmploymentStatusUseCase: FetchEmploymentStatusUseCase

    public init(
        fetchEmploymentStatusUseCase: FetchEmploymentStatusUseCase,
        classNumber: Int,
        year: Int
    ) {
        self.initialState = .init(classNumber: classNumber, year: year)
        self.fetchEmploymentStatusUseCase = fetchEmploymentStatusUseCase
    }

    public enum Action {
        case fetchClassEmployment
    }

    public enum Mutation {
        case setClassInfo(EmploymentEntity)
    }

    public struct State {
        var classInfo: EmploymentEntity = .empty
        let classNumber: Int
        let year: Int
    }
}

extension ClassEmploymentReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchClassEmployment:
            return fetchEmploymentStatusUseCase.execute(year: currentState.year)
                .asObservable()
                .map { [classNumber = currentState.classNumber] employments in
                    employments.first { $0.classID == classNumber } ??
                    EmploymentEntity.empty.with(classID: classNumber)
                }
                .catchAndReturn(.empty)
                .flatMap { classInfo -> Observable<Mutation> in
                    .just(.setClassInfo(classInfo))
                }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setClassInfo(classInfo):
            newState.classInfo = classInfo
        }
        return newState
    }
}
