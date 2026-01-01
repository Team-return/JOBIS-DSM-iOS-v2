import RxSwift

public struct FetchReviewDetailUseCase {
    public init(reviewsRepository: ReviewsRepository) {
        self.reviewsRepository = reviewsRepository
    }

    private let reviewsRepository: ReviewsRepository

    public func execute(reviewID: String) -> Single<ReviewDetailEntity> {
        reviewsRepository.fetchReviewDetail(reviewID: reviewID)
    }
}
