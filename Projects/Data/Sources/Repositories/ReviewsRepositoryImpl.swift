import RxSwift
import Domain

final class ReviewsRepositoryImpl: ReviewsRepository {
    private let reviewsRemote: any ReviewsRemote

    init(reviewsRemote: any ReviewsRemote) {
        self.reviewsRemote = reviewsRemote
    }

    func fetchReviewDetail(id: String) -> Single<[QnaEntity]> {
        reviewsRemote.fetchReviewDetail(id: id)
    }
    
    func fetchReviewList(id: String) -> Single<[ReviewEntity]> {
        reviewsRemote.fetchReviewList(id: id)
    }
    
    func postReview(req: PostReviewRequestQuery) -> Completable {
        reviewsRemote.postReview(req: req)
    }
}
