import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ReviewReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchReviewListUseCase: FetchReviewListUseCase

    public init(
        fetchReviewListUseCase: FetchReviewListUseCase
    ) {
        self.initialState = .init()
        self.fetchReviewListUseCase = fetchReviewListUseCase
    }

    public enum Action {
        case fetchReviewList
        case loadMoreReviews
        case reviewDidSelect(Int)
        case searchButtonDidTap
        case filterButtonDidTap
        case updateFilterOptions(code: String, years: [String], type: String, location: String)
    }

    public enum Mutation {
        case setReviewList([ReviewEntity])
        case appendReviewList([ReviewEntity])
        case incrementPageCount
        case resetPageCount
        case setFilterOptions(code: String, years: [String], type: String, location: String)
    }

    public struct State {
        var reviewList: [ReviewEntity] = []
        var code: String = ""
        var years: [String] = []
        var type: String = ""
        var location: String = ""
        var pageCount: Int = 1
    }
}

extension ReviewReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchReviewList:
            return .concat([
                .just(.resetPageCount),
                fetchReviewListUseCase.execute(
                    page: 1,
                    location: currentState.location,
                    type: currentState.type,
                    years: currentState.years,
                    code: currentState.code
                )
                .asObservable()
                .flatMap { list -> Observable<Mutation> in
                    return .just(.setReviewList(list))
                }
            ])

        case .loadMoreReviews:
            let nextPage = currentState.pageCount + 1
            return fetchReviewListUseCase.execute(
                page: nextPage,
                location: currentState.location,
                type: currentState.type,
                years: currentState.years,
                code: currentState.code
            )
            .asObservable()
            .catch { _ in .empty() }
            .filter { !$0.isEmpty }
            .flatMap { list -> Observable<Mutation> in
                return .concat([
                    .just(.appendReviewList(list)),
                    .just(.incrementPageCount)
                ])
            }

        case let .reviewDidSelect(reviewID):
            steps.accept(ReviewStep.reviewDetailIsRequired(reviewId: String(reviewID)))
            return .empty()

        case .searchButtonDidTap:
            steps.accept(ReviewStep.searchReviewIsRequired)
            return .empty()

        case .filterButtonDidTap:
            steps.accept(ReviewStep.reviewFilterIsRequired)
            return .empty()

        case let .updateFilterOptions(code, years, type, location):
            return .just(.setFilterOptions(code: code, years: years, type: type, location: location))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setReviewList(list):
            newState.reviewList = list

        case let .appendReviewList(list):
            newState.reviewList.append(contentsOf: list)

        case .incrementPageCount:
            newState.pageCount += 1

        case .resetPageCount:
            newState.pageCount = 1

        case let .setFilterOptions(code, years, type, location):
            newState.code = code
            newState.years = years
            newState.type = type
            newState.location = location
        }
        return newState
    }
}
