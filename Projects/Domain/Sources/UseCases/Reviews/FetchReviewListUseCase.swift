import RxSwift

public struct FetchReviewListUseCase {
    public init(reviewsRepository: ReviewsRepository) {
        self.reviewsRepository = reviewsRepository
    }

    private let reviewsRepository: ReviewsRepository

    public func execute(id: Int) -> Single<[ReviewEntity]> {
        return reviewsRepository.fetchReviewList(id: id)
    }
}
