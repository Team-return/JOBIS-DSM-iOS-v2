import RxSwift

public struct FetchReviewListCountUseCase {
    public init(reviewsRepository: ReviewsRepository) {
        self.reviewsRepository = reviewsRepository
    }

    private let reviewsRepository: ReviewsRepository

    public func execute(
        location: LocationType? = nil,
        interviewType: InterviewFormat? = nil,
        companyID: Int? = nil,
        year: Int? = nil,
        jobCode: Int? = nil
    ) -> Single<Int> {
        let request = ReviewListPageCountRequestQuery(
            location: location,
            interviewType: interviewType,
            companyID: companyID,
            year: year,
            jobCode: jobCode
        )

        return reviewsRepository.fetchReviewListPageCount(req: request)
    }
}
