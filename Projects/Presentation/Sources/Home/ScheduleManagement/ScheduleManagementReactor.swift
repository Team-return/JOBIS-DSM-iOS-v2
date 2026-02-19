import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ScheduleManagementReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State

    private let fetchInterviewScheduleListUseCase: FetchInterviewScheduleListUseCase

    public init(fetchInterviewScheduleListUseCase: FetchInterviewScheduleListUseCase) {
        let calendar = Calendar.current
        let now = Date()
        self.fetchInterviewScheduleListUseCase = fetchInterviewScheduleListUseCase
        self.initialState = .init(
            currentYear: calendar.component(.year, from: now),
            currentMonth: calendar.component(.month, from: now),
            todayDay: calendar.component(.day, from: now),
            selectedDay: calendar.component(.day, from: now)
        )
    }

    public enum TabType: Equatable {
        case calendar, edit
    }

    public enum Action {
        case fetchScheduleList
        case calendarTabDidTap
        case editTabDidTap
        case prevMonthDidTap
        case nextMonthDidTap
        case dayDidSelect(Int)
        case scheduleDidSelect(Int)
    }

    public enum Mutation {
        case setScheduleList([InterviewScheduleEntity])
        case setTab(TabType)
        case setMonth(year: Int, month: Int)
        case setSelectedDay(Int)
        case setSelectedScheduleIndex(Int?)
    }

    public struct State {
        var selectedTab: TabType = .calendar
        var currentYear: Int
        var currentMonth: Int
        var todayDay: Int
        var selectedDay: Int?
        var scheduleList: [InterviewScheduleEntity] = []
        var selectedScheduleIndex: Int?
    }
}

extension ScheduleManagementReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchScheduleList:
            return fetchInterviewScheduleListUseCase
                .execute(year: currentState.currentYear, month: currentState.currentMonth)
                .asObservable()
                .map { .setScheduleList($0.interviews) }
                .catch { _ in .empty() }

        case .calendarTabDidTap:
            return .concat([
                .just(.setTab(.calendar)),
                .just(.setSelectedScheduleIndex(nil))
            ])

        case .editTabDidTap:
            return .just(.setTab(.edit))

        case .prevMonthDidTap:
            let (year, month) = prevMonth(currentState.currentYear, currentState.currentMonth)
            return .concat([
                .just(.setMonth(year: year, month: month)),
                fetchInterviewScheduleListUseCase
                    .execute(year: year, month: month)
                    .asObservable()
                    .map { .setScheduleList($0.interviews) }
                    .catch { _ in .empty() }
            ])

        case .nextMonthDidTap:
            let (year, month) = nextMonth(currentState.currentYear, currentState.currentMonth)
            return .concat([
                .just(.setMonth(year: year, month: month)),
                fetchInterviewScheduleListUseCase
                    .execute(year: year, month: month)
                    .asObservable()
                    .map { .setScheduleList($0.interviews) }
                    .catch { _ in .empty() }
            ])

        case let .dayDidSelect(day):
            return .just(.setSelectedDay(day))

        case let .scheduleDidSelect(index):
            let selectedIndex = currentState.selectedScheduleIndex == index ? nil : index
            return .just(.setSelectedScheduleIndex(selectedIndex))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setScheduleList(list):
            newState.scheduleList = list
        case let .setTab(tab):
            newState.selectedTab = tab
        case let .setMonth(year, month):
            newState.currentYear = year
            newState.currentMonth = month
            newState.selectedDay = nil
        case let .setSelectedDay(day):
            newState.selectedDay = day
        case let .setSelectedScheduleIndex(index):
            newState.selectedScheduleIndex = index
        }
        return newState
    }

    private func prevMonth(_ year: Int, _ month: Int) -> (Int, Int) {
        month == 1 ? (year - 1, 12) : (year, month - 1)
    }

    private func nextMonth(_ year: Int, _ month: Int) -> (Int, Int) {
        month == 12 ? (year + 1, 1) : (year, month + 1)
    }
}
