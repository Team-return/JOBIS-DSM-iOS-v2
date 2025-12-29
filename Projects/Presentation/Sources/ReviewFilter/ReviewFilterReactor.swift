import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ReviewFilterReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchCodeListUseCase: FetchCodeListUseCase

    public init(
        fetchCodeListUseCase: FetchCodeListUseCase
    ) {
        self.initialState = .init()
        self.fetchCodeListUseCase = fetchCodeListUseCase
    }

    public enum Action {
        case fetchCodeLists
        case selectJobCode(CodeEntity)
        case selectYear([String])
        case selectInterviewType(CodeEntity)
        case selectLocation(CodeEntity)
        case filterApplyButtonDidTap
    }

    public enum Mutation {
        case setJobList([CodeEntity])
        case setInterviewTypeList([CodeEntity])
        case setRegionList([CodeEntity])
        case setJobCode(String)
        case setYears([String])
        case setInterviewType(String)
        case setLocation(String)
    }

    public struct State {
        var jobList: [CodeEntity] = []
        var interviewTypeList: [CodeEntity] = []
        var regionList: [CodeEntity] = []
        var code: String = ""
        var years: [String] = []
        var type: String = ""
        var location: String = ""
    }
}

extension ReviewFilterReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchCodeLists:
            return .merge([
                fetchCodeListUseCase.execute(keyword: nil, type: .job, parentCode: nil)
                    .asObservable()
                    .map { Mutation.setJobList($0) },
                Observable.just(InterviewFormat.allCases.map { format in
                    CodeEntity(code: format.rawValue.hashValue, keyword: format.rawValue)
                })
                .map { Mutation.setInterviewTypeList($0) },
                Observable.just(LocationType.allCases.map { location in
                    CodeEntity(code: location.rawValue.hashValue, keyword: location.rawValue)
                })
                .map { Mutation.setRegionList($0) }
            ])

        case let .selectJobCode(code):
            return .just(.setJobCode(String(code.code)))

        case let .selectYear(years):
            return .just(.setYears(years))

        case let .selectInterviewType(code):
            return .just(.setInterviewType(code.keyword))

        case let .selectLocation(code):
            return .just(.setLocation(code.keyword))

        case .filterApplyButtonDidTap:
            steps.accept(ReviewFilterStep.popToReview(
                code: currentState.code,
                year: currentState.years,
                type: currentState.type,
                location: currentState.location
            ))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setJobList(list):
            newState.jobList = list

        case let .setInterviewTypeList(list):
            newState.interviewTypeList = list

        case let .setRegionList(list):
            newState.regionList = list

        case let .setJobCode(code):
            newState.code = code

        case let .setYears(years):
            newState.years = years

        case let .setInterviewType(type):
            newState.type = type

        case let .setLocation(location):
            newState.location = location
        }
        return newState
    }
}
