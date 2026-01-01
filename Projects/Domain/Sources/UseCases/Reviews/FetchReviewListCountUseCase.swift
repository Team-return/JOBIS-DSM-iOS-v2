import RxSwift

public struct FetchReviewListCountUseCase {
    public init(reviewsRepository: ReviewsRepository) {
        self.reviewsRepository = reviewsRepository
    }

    private let reviewsRepository: ReviewsRepository

    public func execute(
        location: LocationType? = nil,
        type: InterviewFormat? = nil,
        companyID: Int? = nil,
        year: Int? = nil,
        code: Int? = nil
    ) -> Single<Int> {
        let request = ReviewListPageCountRequestQuery(
            location: location,
            type: type,
            companyID: companyID,
            year: year,
            code: code
        )

        return reviewsRepository.fetchReviewListPageCount(req: request)
    }
}
