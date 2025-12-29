import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class SearchRecruitmentReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let fetchRecruitmentListUseCase: FetchRecruitmentListUseCase
    private let bookmarkUseCase: BookmarkUseCase

    public init(
        fetchRecruitmentListUseCase: FetchRecruitmentListUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.initialState = .init()
        self.fetchRecruitmentListUseCase = fetchRecruitmentListUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    public enum Action {
        case loadMoreRecruitments
        case searchButtonDidTap(String)
        case bookmarkButtonDidTap(Int)
        case recruitmentDidSelect(Int)
    }

    public enum Mutation {
        case setRecruitmentList([RecruitmentEntity])
        case appendRecruitmentList([RecruitmentEntity])
        case incrementPageCount
        case resetPageCount
        case setSearchText(String?)
    }

    public struct State {
        var recruitmentList: [RecruitmentEntity] = []
        var searchText: String?
        var pageCount: Int = 1
    }
}

extension SearchRecruitmentReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadMoreRecruitments:
            let nextPage = currentState.pageCount + 1
            guard let searchText = currentState.searchText else {
                return .empty()
            }
            return .concat([
                .just(.incrementPageCount),
                fetchRecruitmentListUseCase.execute(page: nextPage, name: searchText)
                    .asObservable()
                    .map { Mutation.appendRecruitmentList($0) }
            ])

        case let .searchButtonDidTap(text):
            guard !text.isEmpty else {
                return .empty()
            }
            return .concat([
                .just(.setSearchText(text)),
                .just(.resetPageCount),
                fetchRecruitmentListUseCase.execute(page: 1, name: text)
                    .asObservable()
                    .map { Mutation.setRecruitmentList($0) }
            ])

        case let .bookmarkButtonDidTap(id):
            return bookmarkUseCase.execute(id: id)
                .asObservable()
                .flatMap { _ in Observable<Mutation>.empty() }

        case let .recruitmentDidSelect(id):
            steps.accept(SearchRecruitmentStep.recruitmentDetailIsRequired(id: id))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRecruitmentList(list):
            newState.recruitmentList = list

        case let .appendRecruitmentList(list):
            newState.recruitmentList.append(contentsOf: list)

        case .incrementPageCount:
            newState.pageCount += 1

        case .resetPageCount:
            newState.pageCount = 1

        case let .setSearchText(text):
            newState.searchText = text
        }
        return newState
    }
}
