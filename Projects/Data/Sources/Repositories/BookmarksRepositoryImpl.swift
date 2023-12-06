import RxSwift
import Domain

struct BookmarksRepositoryImpl: BookmarksRepository {
    private let remoteBookmarksDataSource: any RemoteBookmarksDataSource

    init(
        remoteBookmarksDataSource: any RemoteBookmarksDataSource
    ) {
        self.remoteBookmarksDataSource = remoteBookmarksDataSource
    }

    func fetchBookmarkList() -> Single<[BookmarkEntity]> {
        remoteBookmarksDataSource.fetchBookmarkList()
    }

    func bookmark(id: Int) -> Completable {
        remoteBookmarksDataSource.bookmark(id: id)
    }
}
