import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ReviewDetailReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let fetchReviewDetailUseCase: FetchReviewDetailUseCase
    private let reviewId: String

    public var reviewID: String {
        return reviewId
    }

    public init(
        fetchReviewDetailUseCase: FetchReviewDetailUseCase,
        reviewId: String
    ) {
        self.fetchReviewDetailUseCase = fetchReviewDetailUseCase
        self.reviewId = reviewId
        self.initialState = .init()
    }

    public enum Action {
        case fetchReviewDetail
        case segmentSelected(Int)
    }

    public enum Mutation {
        case setReviewDetail(ReviewDetailEntity)
        case updateSegmentIndex(Int)
    }

    public struct State {
        var reviewDetailEntity: ReviewDetailEntity?
        var currentSegmentIndex: Int = 0
        var writer: String = ""
        var year: String = ""
        var major: String = ""
        var companyName: String = ""
        var locationType: LocationType?
        var interviewFormat: InterviewFormat?
        var interviewerCount: Int = 0
        var interviewReview: [QnAEntity] = []
        var expectedQuestion: [QnAEntity] = []
        var currentQnAs: [QnAEntity] = []
        var titleText: String = ""
        var locationText: String = ""
        var interviewFormatText: String = ""

        mutating func update(with entity: ReviewDetailEntity) {
            self.reviewDetailEntity = entity
            self.writer = entity.writer
            self.year = "\(entity.year)"
            self.major = entity.major
            self.companyName = entity.companyName
            self.locationType = entity.location
            self.interviewFormat = entity.type
            self.interviewerCount = entity.interviewerCount
            self.interviewReview = entity.qnAs
            self.titleText = "\(entity.writer)의 면접 후기"
            self.locationText = entity.location.koreanName
            self.interviewFormatText = entity.type.koreanName
            self.currentQnAs = entity.qnAs

            let qna = QnAEntity(id: 0, question: entity.question, answer: entity.answer)
            self.expectedQuestion = [qna]
        }
    }
}

extension ReviewDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchReviewDetail:
            return fetchReviewDetailUseCase.execute(reviewID: reviewId)
                .asObservable()
                .map { Mutation.setReviewDetail($0) }

        case let .segmentSelected(index):
            return .just(.updateSegmentIndex(index))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setReviewDetail(entity):
            newState.update(with: entity)

        case let .updateSegmentIndex(index):
            newState.currentSegmentIndex = index
            if index == 0 {
                newState.titleText = "\(newState.writer)의 면접 후기"
                newState.currentQnAs = newState.interviewReview
            } else {
                newState.titleText = "\(newState.writer)의 받은 면접 질문"
                newState.currentQnAs = newState.expectedQuestion
            }
        }

        return newState
    }
}
