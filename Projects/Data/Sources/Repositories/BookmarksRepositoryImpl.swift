import Domain
import RxSwift
import RxCocoa

public struct BookmarksRepositoryImpl: BookmarksRepository {
    private let bookmarksRemote: any BookmarksRemote

    public init(
        bookmarksRemote: any BookmarksRemote
    ) {
        self.bookmarksRemote = bookmarksRemote
    }

    public func fetchBookmarkList() -> Single<[BookmarkEntity]> {
        bookmarksRemote.fetchBookmarkList()
    }

    public func bookmark(id: Int) -> Completable {
        bookmarksRemote.bookmark(id: id)
    }
}
