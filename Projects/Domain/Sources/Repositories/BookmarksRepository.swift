import RxSwift
import RxCocoa

public protocol BookmarksRepository {
    func fetchBookmarkList() -> Single<[BookmarkEntity]>
    func bookmark(id: Int) -> Completable
}
