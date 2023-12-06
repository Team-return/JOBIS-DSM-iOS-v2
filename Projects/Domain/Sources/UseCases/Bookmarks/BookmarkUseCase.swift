import RxSwift

public struct BookmarkUseCase {
    private let bookmarksRepository: any BookmarksRepository

    public init(bookmarksRepository: any BookmarksRepository) {
        self.bookmarksRepository = bookmarksRepository
    }

    public func execute(id: Int) -> Completable {
        bookmarksRepository.bookmark(id: id)
    }
}
