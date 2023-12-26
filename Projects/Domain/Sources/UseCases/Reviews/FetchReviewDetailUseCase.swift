import RxSwift

public struct FetchReviewDetailUseCase {
    public init(reviewsRepository: ReviewsRepository) {
        self.reviewsRepository = reviewsRepository
    }

    private let reviewsRepository: ReviewsRepository

    public func execute(id: Int) -> Single<[QnaEntity]> {
        return reviewsRepository.fetchReviewDetail(id: id)
    }
}
