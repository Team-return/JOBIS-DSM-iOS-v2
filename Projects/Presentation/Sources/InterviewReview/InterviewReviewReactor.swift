import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain
import ReactorKit

public final class InterviewReviewDetailReactor: BaseReactor {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()

    private let reviewId: String
    private let fetchReviewDetailUseCase: FetchReviewDetailUseCase

    public enum Action {
        case fetchReviewDetail
    }

    public enum Mutation {
        case setReviewDetail(ReviewDetailEntity)
    }

    public struct State {
        var reviewDetailEntity: ReviewDetailEntity?
        var writerName: String
        var qnAs: [QnAEntity] = []
    }

    public init(
        fetchReviewDetailUseCase: FetchReviewDetailUseCase,
        reviewId: String
    ) {
        self.fetchReviewDetailUseCase = fetchReviewDetailUseCase
        self.reviewId = reviewId
        self.initialState = State(writerName: "")
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchReviewDetail:
            return fetchReviewDetailUseCase.execute(reviewID: reviewId)
                .asObservable()
                .map { Mutation.setReviewDetail($0) }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setReviewDetail(entity):
            newState.reviewDetailEntity = entity
            newState.writerName = entity.writer
            newState.qnAs = entity.qnAs
        }

        return newState
    }
}
