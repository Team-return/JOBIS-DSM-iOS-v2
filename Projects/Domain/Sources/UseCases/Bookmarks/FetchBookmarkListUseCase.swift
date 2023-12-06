import RxSwift

public struct FetchBookmarkListUseCase {
    private let bookmarksRepository: any BookmarksRepository

    public init(bookmarksRepository: any BookmarksRepository) {
        self.bookmarksRepository = bookmarksRepository
    }

    public func execute() -> Single<[BookmarkEntity]> {
        bookmarksRepository.fetchBookmarkList()
    }
}
