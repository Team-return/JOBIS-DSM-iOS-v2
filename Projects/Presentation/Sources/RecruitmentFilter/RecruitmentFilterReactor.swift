import Foundation
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
        case toggleStatus(Int)
        case appendTechCode(String)
        case resetTechCode
    }

    public struct State {
        var jobList: [CodeEntity] = []
        var techList: [CodeEntity] = []
        var jobCode: String = ""
        var statusCode: Int?
        var years: [String] = []
        var techCode: [String] = []
        let yearList: [CodeEntity] = {
            let currentYear = Calendar.current.component(.year, from: Date())
            return (2023...currentYear).reversed().map {
                CodeEntity(code: $0, keyword: "\($0)")
            }
        }()
        let stateList: [CodeEntity] = [
            CodeEntity(code: 0, keyword: "모집중"),
            CodeEntity(code: 1, keyword: "모집 종료")
        ]
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
            return .just(.toggleStatus(code.code))

        case .filterApplyButtonDidTap:
            let statusString = mapStatus(code: currentState.statusCode)
            steps.accept(RecruitmentFilterStep.popToRecruitment(
                jobCode: currentState.jobCode,
                techCode: currentState.techCode,
                years: currentState.years,
                status: statusString
            ))
            return .empty()

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

        case let .toggleStatus(code):
            newState.statusCode = (newState.statusCode == code) ? nil : code

        case let .appendTechCode(code):
            newState.techCode.append(code)

        case .resetTechCode:
            newState.techCode = []
        }
        return newState
    }

    private func mapStatus(code: Int?) -> String {
        guard let code = code else { return "" }
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
