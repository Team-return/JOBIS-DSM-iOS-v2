import RxSwift

public protocol ReviewsRepository {
    func fetchReviewList(id: Int) -> Single<[ReviewEntity]>
    func postReview(req: PostReviewRequestQuery) -> Completable
    func fetchReviewListPageCount(req: ReviewListPageCountRequestQuery) -> Single<Int>
}
