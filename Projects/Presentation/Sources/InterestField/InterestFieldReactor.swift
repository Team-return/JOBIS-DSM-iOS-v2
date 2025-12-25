import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class InterestFieldReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchCodeListUseCase: FetchCodeListUseCase
    private let changeInterestsUseCase: ChangeInterestsUseCase
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase

    public init(
        fetchCodeListUseCase: FetchCodeListUseCase,
        changeInterestsUseCase: ChangeInterestsUseCase,
        fetchStudentInfoUseCase: FetchStudentInfoUseCase
    ) {
        self.initialState = .init()
        self.fetchCodeListUseCase = fetchCodeListUseCase
        self.changeInterestsUseCase = changeInterestsUseCase
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
    }

    public enum Action {
        case viewWillAppear
        case toggleInterest(CodeEntity)
        case selectButtonDidTap
    }

    public enum Mutation {
        case setAvailableInterests([CodeEntity])
        case setStudentName(String)
        case toggleSelectedInterest(CodeEntity)
    }

    public struct State {
        var availableInterests: [CodeEntity] = []
        var selectedInterests: [CodeEntity] = []
        var studentName: String = ""

        var selectedCount: Int {
            selectedInterests.count
        }
    }
}

extension InterestFieldReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let interests = fetchCodeListUseCase.execute(
                keyword: nil,
                type: .job,
                parentCode: nil
            )
            .asObservable()
            .map { Mutation.setAvailableInterests($0) }

            let studentInfo = fetchStudentInfoUseCase.execute()
                .asObservable()
                .map { Mutation.setStudentName($0.studentName) }

            return .merge(interests, studentInfo)

        case let .toggleInterest(interest):
            return .just(.toggleSelectedInterest(interest))

        case .selectButtonDidTap:
            let codeIDs = currentState.selectedInterests.map { $0.code }
            return changeInterestsUseCase.execute(codeIDs: codeIDs)
                .asObservable()
                .do(onCompleted: { [weak self] in
                    self?.steps.accept(InterestFieldStep.interestFieldCheckIsRequired)
                })
                .flatMap { _ in Observable<Mutation>.empty() }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setAvailableInterests(interests):
            newState.availableInterests = interests

        case let .setStudentName(name):
            newState.studentName = name

        case let .toggleSelectedInterest(interest):
            if let index = newState.selectedInterests.firstIndex(where: { $0.code == interest.code }) {
                newState.selectedInterests.remove(at: index)
            } else {
                newState.selectedInterests.append(interest)
            }
        }

        return newState
    }
}
