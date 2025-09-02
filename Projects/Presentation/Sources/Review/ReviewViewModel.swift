import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ReviewViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    public var reviewData = BehaviorRelay<[ReviewEntity]>(value: [])
    private let fetchReviewListUseCase: FetchReviewListUseCase
    private var pageCount: Int = 1
    public var jobCode: Int = 1

    init(
        fetchReviewListUseCase: FetchReviewListUseCase,
    ) {
        self.fetchReviewListUseCase = fetchReviewListUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        var pageChange: Observable<WillDisplayCellEvent>
        let reviewTableViewDidTap: Observable<Int>
        let searchButtonDidTap: Signal<Void>
        let filterButtonDidTap: Signal<Void>
    }
    public struct Output {
        var reviewData = BehaviorRelay<[ReviewEntity]>(value: [])
    }

    public func transform(_ input: Input) -> Output {
        input.viewAppear.asObservable()
            .flatMap {
                self.pageCount = 1
                return self.fetchReviewListUseCase.execute(
                    page: self.pageCount,
                    jobCode: self.jobCode
                )
            }
            .bind(onNext: {
                self.reviewData.accept([])
                self.reviewData.accept(self.reviewData.value + $0)
                self.pageCount = 1
            })
            .disposed(by: disposeBag)

        input.reviewTableViewDidTap.asObservable()
            .map {
                ReviewStep.reviewDetailIsRequired(
                    reviewId: $0
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.searchButtonDidTap.asObservable()
            .map {
                ReviewStep.searchReviewIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(reviewData: reviewData)
    }
}
