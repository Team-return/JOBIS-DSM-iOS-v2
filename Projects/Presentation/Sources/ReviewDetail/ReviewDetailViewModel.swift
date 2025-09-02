import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ReviewDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    public var reviewID: String?

    private let fetchReviewDetailUseCase: FetchReviewDetailUseCase

    init(
        fetchReviewDetailUseCase: FetchReviewDetailUseCase
    ) {
        self.fetchReviewDetailUseCase = fetchReviewDetailUseCase
    }

    public struct Input {
        let viewDidLoad: PublishRelay<Void>
    }
    public struct Output {
        let reviewDetailEntity: PublishRelay<ReviewDetailEntity>
    }

    public func transform(_ input: Input) -> Output {
        let reviewDetailEntity = PublishRelay<ReviewDetailEntity>()

        input.viewDidLoad.asObservable()
            .flatMap {
                self.fetchReviewDetailUseCase.execute(reviewID: self.reviewID ?? "")
            }
            .bind {
                reviewDetailEntity.accept($0)
            }
            .disposed(by: disposeBag)
        return Output(reviewDetailEntity: reviewDetailEntity)
    }
}
