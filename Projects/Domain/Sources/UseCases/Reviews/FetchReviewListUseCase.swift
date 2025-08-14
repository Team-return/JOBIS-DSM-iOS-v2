import RxSwift

public struct FetchReviewListUseCase {
    public init(reviewsRepository: ReviewsRepository) {
        self.reviewsRepository = reviewsRepository
    }

    private let reviewsRepository: ReviewsRepository

    public func execute(
        page: Int? = nil,
        location: LocationType? = nil,
        interviewType: InterviewFormat? = nil,
        companyID: Int? = nil,
        keyword: String? = nil,
        year: Int? = nil,
        jobCode: Int? = nil
    ) -> Single<[ReviewEntity]> {
        let request = ReviewListRequestQuery(
            page: page,
            location: location,
            interviewType: interviewType,
            companyID: companyID,
            keyword: keyword,
            year: year,
            jobCode: jobCode
        )

        return reviewsRepository.fetchReviewList(req: request)
    }
}
