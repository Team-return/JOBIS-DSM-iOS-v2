import Domain
import RxSwift
import RxCocoa

public struct BookmarksRepositoryImpl: BookmarksRepository {
    private let remoteBookmarksDataSource: any RemoteBookmarksDataSource

    public init(
        remoteBookmarksDataSource: any RemoteBookmarksDataSource
    ) {
        self.remoteBookmarksDataSource = remoteBookmarksDataSource
    }

    public func fetchBookmarkList() -> Single<[BookmarkEntity]> {
        remoteBookmarksDataSource.fetchBookmarkList()
    }

    public func bookmark(id: Int) -> Completable {
        remoteBookmarksDataSource.bookmark(id: id)
    }
}
