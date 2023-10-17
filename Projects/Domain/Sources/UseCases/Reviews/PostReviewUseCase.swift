import RxSwift

public struct PostReviewUseCase {
    public init(reviewsRepository: ReviewsRepository) {
        self.reviewsRepository = reviewsRepository
    }

    private let reviewsRepository: ReviewsRepository

    public func execute(req: PostReviewRequestQuery) -> Completable {
        return reviewsRepository.postReview(req: req)
    }
}
