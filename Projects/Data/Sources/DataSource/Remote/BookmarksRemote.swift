import RxSwift
import RxCocoa
import Domain

public protocol BookmarksRemote {
    func fetchBookmarkList() -> Single<[BookmarkEntity]>
    func bookmark(id: Int) -> Completable
}

final class BookmarksRemoteImpl: BaseRemote<BookmarksAPI>, BookmarksRemote {
    public func fetchBookmarkList() -> Single<[BookmarkEntity]> {
        request(.fetchBookmarkList)
            .map(BookmarkListResponseDTO.self)
            .map {
                $0.toDomain()
            }
    }

    public func bookmark(id: Int) -> Completable {
        request(.bookmark(id: id))
            .asCompletable()
    }
}
