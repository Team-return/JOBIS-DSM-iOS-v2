import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class EmployStatusReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase

    public init(
        fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase
    ) {
        self.initialState = .init()
        self.fetchTotalPassStudentUseCase = fetchTotalPassStudentUseCase
    }

    public enum Action {
        case viewWillAppear
        case updateYear(Int)
        case classButtonTapped(Int)
        case filterButtonDidTap
    }

    public enum Mutation {
        case setTotalPassStudentInfo(TotalPassStudentEntity)
        case setSelectedYear(Int)
    }

    public struct State {
        var totalPassStudentInfo: TotalPassStudentEntity = TotalPassStudentEntity(
            totalStudentCount: 0,
            passedCount: 0,
            approvedCount: 0
        )
        var selectedYear: Int = Calendar.current.component(.year, from: Date())
    }
}

extension EmployStatusReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchTotalPassStudentUseCase.execute(year: currentState.selectedYear)
                .asObservable()
                .flatMap { info -> Observable<Mutation> in
                    .just(.setTotalPassStudentInfo(info))
                }

        case let .updateYear(year):
            return .concat([
                .just(.setSelectedYear(year)),
                fetchTotalPassStudentUseCase.execute(year: year)
                    .asObservable()
                    .flatMap { info -> Observable<Mutation> in
                        .just(.setTotalPassStudentInfo(info))
                    }
            ])

        case let .classButtonTapped(classNumber):
            steps.accept(EmployStatusStep.classEmploymentIsRequired(
                classNumber: classNumber,
                year: currentState.selectedYear
            ))
            return .empty()

        case .filterButtonDidTap:
            steps.accept(EmployStatusStep.employmentFilterIsRequired(
                currentYear: currentState.selectedYear
            ))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setTotalPassStudentInfo(info):
            newState.totalPassStudentInfo = info

        case let .setSelectedYear(year):
            newState.selectedYear = year
        }
        return newState
    }

    public func updateYear(_ year: Int) {
        action.onNext(.updateYear(year))
    }

    public func getCurrentYear() -> Int {
        return currentState.selectedYear
    }
}
