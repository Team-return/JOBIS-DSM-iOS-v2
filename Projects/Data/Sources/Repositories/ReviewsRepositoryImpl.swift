import RxSwift
import Domain

struct ReviewsRepositoryImpl: ReviewsRepository {
    private let remoteReviewsDataSource: any RemoteReviewsDataSource

    init(remoteReviewsDataSource: any RemoteReviewsDataSource) {
        self.remoteReviewsDataSource = remoteReviewsDataSource
    }

    func postReview(req: PostReviewRequestQuery) -> Completable {
        remoteReviewsDataSource.postReview(req: req)
    }

    func fetchReviewListPageCount(req: Domain.ReviewListPageCountRequestQuery) -> RxSwift.Single<Int> {
        remoteReviewsDataSource.fetchReviewListPageCount(req: req)
            .map { $0.totalPageCount }
    }

    func fetchReviewDetail(reviewID: String) -> Single<ReviewDetailEntity> {
        remoteReviewsDataSource.fetchReviewDetail(reviewID: reviewID)
            .map { $0.toDomain() }
    }
}
