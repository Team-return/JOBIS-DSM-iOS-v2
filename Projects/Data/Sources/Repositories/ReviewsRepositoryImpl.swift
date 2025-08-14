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
}
