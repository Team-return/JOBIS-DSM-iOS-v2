import RxSwift

public protocol ReviewsRepository {
    func fetchReviewDetail(id: String) -> Single<[QnaEntity]>
    func fetchReviewList(id: String) -> Single<[ReviewEntity]>
    func postReview(req: PostReviewRequestQuery) -> Completable
}
