import RxSwift

public protocol ReviewsRepository {
    func postReview(req: PostReviewRequestQuery) -> Completable
    func fetchReviewListPageCount(req: ReviewListPageCountRequestQuery) -> Single<Int>
}
