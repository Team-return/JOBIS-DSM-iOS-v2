import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class InterviewReviewDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    public var reviewId: Int = 0
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
        let qnaListEntity: PublishRelay<[QnAEntity]>
        let writerName: String
    }

    public func transform(_ input: Input) -> Output {
        let qnaListEntity = PublishRelay<[QnAEntity]>()

        input.viewWillAppear.asObservable()
            .flatMap {
                self.fetchReviewDetailUseCase.execute(id: self.reviewId)
            }
            .bind(to: qnaListEntity)
            .disposed(by: disposeBag)

        return Output(
            qnaListEntity: qnaListEntity,
            writerName: writerName
        )
    }
}
