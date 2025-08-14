import RxSwift

public protocol ReviewsRepository {
    func postReview(req: PostReviewRequestQuery) -> Completable
    func fetchReviewListPageCount(req: ReviewListPageCountRequestQuery) -> Single<Int>
    func fetchReviewDetail(reviewID: String) -> Single<ReviewDetailEntity>
    func fetchReviewList(req: ReviewListRequestQuery) -> Single<[ReviewEntity]>
}
