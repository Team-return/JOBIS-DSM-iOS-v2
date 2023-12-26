import RxSwift

public protocol ReviewsRepository {
    func fetchReviewDetail(id: Int) -> Single<[QnaEntity]>
    func fetchReviewList(id: Int) -> Single<[ReviewEntity]>
    func postReview(req: PostReviewRequestQuery) -> Completable
}
