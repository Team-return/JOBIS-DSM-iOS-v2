import RxSwift
import Domain

public protocol RemoteReviewsDataSource {
    func postReview(req: PostReviewRequestQuery) -> Completable
    func fetchReviewListPageCount(req: ReviewListPageCountRequestQuery) -> Single<ReviewListPageCountResponseDTO>
}

final class RemoteReviewsDataSourceImpl: RemoteBaseDataSource<ReviewsAPI>, RemoteReviewsDataSource {
    func postReview(req: PostReviewRequestQuery) -> Completable {
        request(.postReview(req))
            .asCompletable()
    }
    
    func fetchReviewListPageCount(req: ReviewListPageCountRequestQuery) -> Single<ReviewListPageCountResponseDTO> {
        request(.reviewListPageCount(req))
            .map(ReviewListPageCountResponseDTO.self)
    }
}
