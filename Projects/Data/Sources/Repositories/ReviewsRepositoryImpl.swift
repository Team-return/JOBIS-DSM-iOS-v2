import RxSwift
import Domain

final class ReviewsRepositoryImpl: ReviewsRepository {
    private let remoteReviewsdataSource: any RemoteReviewsdataSource

    init(remoteReviewsdataSource: any RemoteReviewsdataSource) {
        self.remoteReviewsdataSource = remoteReviewsdataSource
    }

    func fetchReviewDetail(id: String) -> Single<[QnaEntity]> {
        remoteReviewsdataSource.fetchReviewDetail(id: id)
    }

    func fetchReviewList(id: String) -> Single<[ReviewEntity]> {
        remoteReviewsdataSource.fetchReviewList(id: id)
    }

    func postReview(req: PostReviewRequestQuery) -> Completable {
        remoteReviewsdataSource.postReview(req: req)
    }
}
