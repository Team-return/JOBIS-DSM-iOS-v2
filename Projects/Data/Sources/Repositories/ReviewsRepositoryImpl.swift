import RxSwift
import Domain

final class ReviewsRepositoryImpl: ReviewsRepository {
    private let remoteReviewsDataSource: any RemoteReviewsDataSource

    init(remoteReviewsDataSource: any RemoteReviewsDataSource) {
        self.remoteReviewsDataSource = remoteReviewsDataSource
    }

    func fetchReviewDetail(id: String) -> Single<[QnaEntity]> {
        remoteReviewsDataSource.fetchReviewDetail(id: id)
    }

    func fetchReviewList(id: String) -> Single<[ReviewEntity]> {
        remoteReviewsDataSource.fetchReviewList(id: id)
    }

    func postReview(req: PostReviewRequestQuery) -> Completable {
        remoteReviewsDataSource.postReview(req: req)
    }
}
