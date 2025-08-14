import RxSwift
import Domain

protocol RemoteReviewsDataSource {
    func postReview(req: PostReviewRequestQuery) -> Completable
}

final class RemoteReviewsDataSourceImpl: RemoteBaseDataSource<ReviewsAPI>, RemoteReviewsDataSource {
    func postReview(req: PostReviewRequestQuery) -> Completable {
        request(.postReview(req))
            .asCompletable()
    }
}
