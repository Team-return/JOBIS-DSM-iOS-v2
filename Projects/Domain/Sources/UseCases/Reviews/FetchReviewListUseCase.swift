import RxSwift

public struct FetchReviewListUseCase {
    public init(reviewsRepository: ReviewsRepository) {
        self.reviewsRepository = reviewsRepository
    }

    private let reviewsRepository: ReviewsRepository

    public func execute(
        page: Int? = nil,
        location: String? = nil,
        type: String? = nil,
        companyID: Int? = nil,
        keyword: String? = nil,
        years: [String]? = [],
        code: String? = nil,
        companyName: String? = nil,
        writer: String? = nil
    ) -> Single<[ReviewEntity]> {
        let request = ReviewListRequestQuery(
            page: page,
            location: location,
            type: type,
            companyID: companyID,
            keyword: keyword,
            years: years,
            code: code,
            companyName: companyName,
            writer: writer
        )

        return reviewsRepository.fetchReviewList(req: request)
    }
}
