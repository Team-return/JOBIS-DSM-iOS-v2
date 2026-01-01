import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain
import ReactorKit

public final class BookmarkReactor: BaseReactor, Reactor {
    public enum Action {
        case viewWillAppear
        case removeBookmark(Int)
        case bookmarkItemDidTap(Int)
    }

    public enum Mutation {
        case setBookmarkList([BookmarkEntity])
        case removeBookmarkFromList(Int)
    }

    public struct State {
        public var bookmarkList: [BookmarkEntity] = []
    }

    public var initialState: State
    public let steps = PublishRelay<Step>()
    private let fetchBookmarkListUseCase: FetchBookmarkListUseCase
    private let bookmarkUseCase: BookmarkUseCase

    public init(
        fetchBookmarkListUseCase: FetchBookmarkListUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.fetchBookmarkListUseCase = fetchBookmarkListUseCase
        self.bookmarkUseCase = bookmarkUseCase
        self.initialState = State()
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchBookmarkListUseCase.execute()
                .asObservable()
                .map { Mutation.setBookmarkList($0) }
                .catch { _ in .empty() }

        case let .removeBookmark(id):
            return .concat([
                .just(.removeBookmarkFromList(id)),
                bookmarkUseCase.execute(id: id)
                    .andThen(Observable<Mutation>.empty())
                    .catch { _ in .empty() }
            ])

        case let .bookmarkItemDidTap(id):
            steps.accept(BookmarkStep.recruitmentDetailIsRequired(id: id))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setBookmarkList(list):
            newState.bookmarkList = list

        case let .removeBookmarkFromList(id):
            newState.bookmarkList = state.bookmarkList.filter { $0.recruitmentID != id }
        }

        return newState
    }
}
