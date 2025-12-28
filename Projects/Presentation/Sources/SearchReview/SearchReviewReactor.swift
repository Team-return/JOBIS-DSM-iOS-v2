import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class SearchReviewReactor: BaseReactor, Stepper {
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
        case viewWillAppear
        case searchTextDidSubmit(String)
        case loadMoreReviews
        case reviewDidSelect(Int)
    }

    public enum Mutation {
        case setReviewList([ReviewEntity])
        case appendReviewList([ReviewEntity])
        case setSearchText(String?)
        case incrementPageCount
        case resetPageCount
        case setEmptyViewHidden(Bool)
    }

    public struct State {
        var reviewList: [ReviewEntity] = []
        var pageCount: Int = 1
        var searchText: String?
        var isEmptyViewHidden: Bool = true
    }
}

extension SearchReviewReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            guard let searchText = currentState.searchText else {
                return .empty()
            }
            return .concat([
                .just(.resetPageCount),
                fetchReviewListUseCase.execute(
                    page: 1,
                    companyName: searchText,
                    writer: searchText
                )
                .asObservable()
                .flatMap { list -> Observable<Mutation> in
                    return .just(.setReviewList(list))
                }
            ])

        case let .searchTextDidSubmit(text):
            guard !text.isEmpty else {
                return .just(.setEmptyViewHidden(false))
            }

            let query = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

            return .concat([
                .just(.setEmptyViewHidden(true)),
                .just(.setSearchText(text)),
                .just(.resetPageCount),
                fetchReviewListUseCase.execute(
                    page: 1,
                    companyName: nil,
                    writer: nil
                )
                .map { list in
                    list.filter { review in
                        let companyMatch = review.companyName.lowercased().contains(query)
                        let writerMatch = review.writer.lowercased().contains(query)
                        return companyMatch || writerMatch
                    }
                }
                .asObservable()
                .flatMap { list -> Observable<Mutation> in
                    return .just(.setReviewList(list))
                }
            ])

        case .loadMoreReviews:
            guard let searchText = currentState.searchText else {
                return .empty()
            }
            let nextPage = currentState.pageCount + 1
            return fetchReviewListUseCase.execute(
                page: nextPage,
                companyName: searchText,
                writer: searchText
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
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setReviewList(list):
            newState.reviewList = list

        case let .appendReviewList(list):
            newState.reviewList.append(contentsOf: list)

        case let .setSearchText(text):
            newState.searchText = text

        case .incrementPageCount:
            newState.pageCount += 1

        case .resetPageCount:
            newState.pageCount = 1

        case let .setEmptyViewHidden(isHidden):
            newState.isEmptyViewHidden = isHidden
        }
        return newState
    }
}
