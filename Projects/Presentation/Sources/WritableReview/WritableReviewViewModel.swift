import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class WritableReviewViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    public var companyID = 0
    private let postReviewUseCase: PostReviewUseCase
    public var interviewReviewInfo = BehaviorRelay<[QnaEntity]>(value: [])
    public var interviewReviewInfoList: [QnaElementRequestQuery] = []
    public var techCode: Int?

    init(
        postReviewUseCase: PostReviewUseCase
    ) {
        self.postReviewUseCase = postReviewUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let addReviewButtonDidTap: PublishRelay<Void>
        let writableReviewButtonDidTap: PublishRelay<Void>
    }

    public struct Output {
        let interviewReviewInfo: BehaviorRelay<[QnaEntity]>
    }

    public func transform(_ input: Input) -> Output {
        input.addReviewButtonDidTap.asObservable()
            .map {
                WritableReviewStep.addReviewIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        self.interviewReviewInfo.asObservable()
            .subscribe(onNext: { data in
                data.forEach { qnaEntity in
                    self.interviewReviewInfoList.append(QnaElementRequestQuery(
                        question: qnaEntity.question,
                        answer: qnaEntity.answer,
                        codeID: self.techCode ?? 0
                    ))
                }
            })
            .disposed(by: disposeBag)

        input.writableReviewButtonDidTap.asObservable()
            .flatMap {
                self.postReviewUseCase.execute(req: PostReviewRequestQuery(
                    companyID: self.companyID,
                    qnaElements: self.interviewReviewInfoList
                ))
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(
            interviewReviewInfo: interviewReviewInfo
        )
    }
}
