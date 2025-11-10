import RxSwift
import Domain

public protocol RemoteReviewsDataSource {
    func postReview(req: PostReviewRequestQuery) -> Completable
    func fetchReviewListPageCount(req: ReviewListPageCountRequestQuery) -> Single<ReviewListPageCountResponseDTO>
    func fetchReviewDetail(reviewID: String) -> Single<ReviewDetailResponseDTO>
    func fetchReviewList(req: ReviewListRequestQuery) -> Single<ReviewListResponseDTO>
    func fetchReviewQuestions() -> Single<ReviewQuestionResponseDTO>
}

final class RemoteReviewsDataSourceImpl: RemoteBaseDataSource<ReviewsAPI>, RemoteReviewsDataSource {
    func postReview(req: PostReviewRequestQuery) -> Completable {
        request(.postReview(req))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }

    func fetchReviewListPageCount(req: ReviewListPageCountRequestQuery) -> Single<ReviewListPageCountResponseDTO> {
        request(.fetchReviewListPageCount(req))
            .map(ReviewListPageCountResponseDTO.self)
    }

    func fetchReviewDetail(reviewID: String) -> Single<ReviewDetailResponseDTO> {
        request(.fetchReviewDetail(reviewID: reviewID))
            .map(ReviewDetailResponseDTO.self)
    }

    func fetchReviewList(req: ReviewListRequestQuery) -> Single<ReviewListResponseDTO> {
        request(.fetchReviewList(req))
            .map(ReviewListResponseDTO.self)
    }

    func fetchReviewQuestions() -> Single<ReviewQuestionResponseDTO> {
            request(.fetchReviewQuestions)
                .map(ReviewQuestionResponseDTO.self)
        }
}
