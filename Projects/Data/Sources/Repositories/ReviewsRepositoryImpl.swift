import RxSwift
import Domain

struct ReviewsRepositoryImpl: ReviewsRepository {
    private let remoteReviewsDataSource: any RemoteReviewsDataSource

    init(remoteReviewsDataSource: any RemoteReviewsDataSource) {
        self.remoteReviewsDataSource = remoteReviewsDataSource
    }

    func fetchReviewDetail(id: Int) -> Single<[QnaEntity]> {
        remoteReviewsDataSource.fetchReviewDetail(id: id)
    }

    func fetchReviewList(id: Int) -> Single<[ReviewEntity]> {
        remoteReviewsDataSource.fetchReviewList(id: id)
    }

    func postReview(req: PostReviewRequestQuery) -> Completable {
        remoteReviewsDataSource.postReview(req: req)
    }
}
