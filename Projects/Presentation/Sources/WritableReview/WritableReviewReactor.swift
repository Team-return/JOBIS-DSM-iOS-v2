import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class WritableReviewReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    public var companyID: Int = 0
    public var companyName: String = ""
    public var jobCode: Int = 0
    public var interviewType: InterviewFormat = .individual
    public var location: LocationType = .seoul
    public var interviewerCount: Int = 1

    public var interviewReviewInfo = PublishRelay<QnAEntity>()

    public init() {
        self.initialState = .init()
    }

    public enum Action {
        case addQuestionButtonDidTap
    }

    public enum Mutation {
        case setQnAInfoList([QnAEntity])
    }

    public struct State {
        var qnaInfoList: [QnAEntity] = []
    }
}

extension WritableReviewReactor {
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let interviewReviewMutation = interviewReviewInfo
            .scan([QnAEntity]()) { oldList, newInfo in
                oldList + [newInfo]
            }
            .map { Mutation.setQnAInfoList($0) }

        return Observable.merge(mutation, interviewReviewMutation)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addQuestionButtonDidTap:
            steps.accept(WritableReviewStep.addReviewIsRequired)
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setQnAInfoList(list):
            newState.qnaInfoList = list
        }
        return newState
    }
}
