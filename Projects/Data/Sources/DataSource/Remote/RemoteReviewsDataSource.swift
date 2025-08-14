import RxSwift
import Domain

public protocol RemoteReviewsDataSource {
    func postReview(req: PostReviewRequestQuery) -> Completable
    func fetchReviewListPageCount(req: ReviewListPageCountRequestQuery) -> Single<ReviewListPageCountResponseDTO>
    func fetchReviewDetail(reviewID: String) -> Single<ReviewDetailResponseDTO>
}

final class RemoteReviewsDataSourceImpl: RemoteBaseDataSource<ReviewsAPI>, RemoteReviewsDataSource {
    func postReview(req: PostReviewRequestQuery) -> Completable {
        request(.postReview(req))
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
}
