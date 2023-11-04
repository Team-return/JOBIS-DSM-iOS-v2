import RxSwift
import RxCocoa
import Domain

public protocol RemoteBookmarksDataSource {
    func fetchBookmarkList() -> Single<[BookmarkEntity]>
    func bookmark(id: Int) -> Completable
}

final class RemoteBookmarksDataSourceImpl: RemoteBaseDataSource<BookmarksAPI>, RemoteBookmarksDataSource {
    public func fetchBookmarkList() -> Single<[BookmarkEntity]> {
        request(.fetchBookmarkList)
            .map(BookmarkListResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func bookmark(id: Int) -> Completable {
        request(.bookmark(id: id))
            .asCompletable()
    }
}
