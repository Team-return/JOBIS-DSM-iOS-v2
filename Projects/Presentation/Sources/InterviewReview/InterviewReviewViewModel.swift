import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class InterviewReviewDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    public var reviewId: String = ""
    public var writerName: String = ""
    let fetchReviewDetailUseCase: FetchReviewDetailUseCase

    init(
        fetchReviewDetailUseCase: FetchReviewDetailUseCase
    ) {
        self.fetchReviewDetailUseCase = fetchReviewDetailUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
    }

    public struct Output {
        let reviewDetailEntity: PublishRelay<ReviewDetailEntity>
        let writerName: String
    }

    public func transform(_ input: Input) -> Output {
        let reviewDetailEntity = PublishRelay<ReviewDetailEntity>()

        input.viewWillAppear.asObservable()
            .flatMap {
                self.fetchReviewDetailUseCase.execute(reviewID: self.reviewId)
            }
            .bind(to: reviewDetailEntity)
            .disposed(by: disposeBag)

        return Output(
            reviewDetailEntity: reviewDetailEntity,
            writerName: writerName
        )
    }
}
