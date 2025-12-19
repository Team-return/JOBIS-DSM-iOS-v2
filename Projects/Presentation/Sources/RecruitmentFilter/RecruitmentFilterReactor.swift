import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentFilterReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
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
        case selectYear(CodeEntity)
        case selectStatus(CodeEntity)
        case filterApplyButtonDidTap
        case appendTechCode(CodeEntity)
        case resetTechCode
    }

    public enum Mutation {
        case setJobList([CodeEntity])
        case setTechList([CodeEntity])
        case toggleJobCode(String)
        case toggleYear(String)
        case toggleStatus(String)
        case appendTechCode(String)
        case resetTechCode
        case applyFilter
    }

    public struct State {
        var jobList: [CodeEntity] = []
        var techList: [CodeEntity] = []
        var jobCode: String = ""
        var status: String = ""
        var years: [String] = []
        var techCode: [String] = []
    }
}

extension RecruitmentFilterReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchCodeLists:
            return .merge([
                fetchCodeListUseCase.execute(keyword: nil, type: .job, parentCode: nil)
                    .asObservable()
                    .map { Mutation.setJobList($0) },
                fetchCodeListUseCase.execute(keyword: nil, type: .tech, parentCode: nil)
                    .asObservable()
                    .map { Mutation.setTechList($0) }
            ])

        case let .selectJobCode(code):
            let jobCodeString = "\(code.code)"
            return .concat([
                .just(.toggleJobCode(jobCodeString)),
                .just(.resetTechCode),
                fetchCodeListUseCase.execute(
                    keyword: nil,
                    type: .tech,
                    parentCode: currentState.jobCode
                )
                .asObservable()
                .map { Mutation.setTechList($0) }
            ])

        case let .selectYear(code):
            return .just(.toggleYear("\(code.code)"))

        case let .selectStatus(code):
            let mappedStatus = mapStatus(code: code.code)
            return .just(.toggleStatus(mappedStatus))

        case .filterApplyButtonDidTap:
            return .just(.applyFilter)

        case let .appendTechCode(code):
            let codeString = "\(code.code)"
            guard !codeString.isEmpty else {
                return .empty()
            }
            return .just(.appendTechCode(codeString))

        case .resetTechCode:
            return .just(.resetTechCode)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setJobList(list):
            newState.jobList = list

        case let .setTechList(list):
            newState.techList = list

        case let .toggleJobCode(code):
            newState.jobCode = (newState.jobCode == code) ? "" : code

        case let .toggleYear(year):
            if let index = newState.years.firstIndex(of: year) {
                newState.years.remove(at: index)
            } else {
                newState.years.append(year)
            }

        case let .toggleStatus(status):
            newState.status = (newState.status == status) ? "" : status

        case let .appendTechCode(code):
            newState.techCode.append(code)

        case .resetTechCode:
            newState.techCode = []

        case .applyFilter:
            steps.accept(RecruitmentFilterStep.popToRecruitment(
                jobCode: state.jobCode,
                techCode: state.techCode,
                years: state.years,
                status: state.status
            ))
        }
        return newState
    }

    private func mapStatus(code: Int) -> String {
        switch code {
        case 0:
            return "RECRUITING"
        case 1:
            return "DONE"
        default:
            return ""
        }
    }
}
