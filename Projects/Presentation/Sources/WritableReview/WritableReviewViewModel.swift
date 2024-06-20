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
    public var interviewReviewInfo = PublishRelay<QnaEntity>()
    public var qnaInfoList = PublishRelay<[QnaEntity]>()
    public var interviewReviewInfoList = BehaviorRelay<[QnaElementRequestQuery]>(value: [])
    public var techCode: Int?

    init(
        postReviewUseCase: PostReviewUseCase
    ) {
        self.postReviewUseCase = postReviewUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let addQuestionButtonDidTap: PublishRelay<Void>
        let writableReviewButtonDidTap: PublishRelay<Void>
    }

    public struct Output {
        let interviewReviewInfoList: BehaviorRelay<[QnaElementRequestQuery]>
        let qnaInfoList: PublishRelay<[QnaEntity]>
    }

    public func transform(_ input: Input) -> Output {
        input.addQuestionButtonDidTap.asObservable()
            .map {
                WritableReviewStep.addReviewIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        self.interviewReviewInfo.asObservable()
            .subscribe(onNext: { qnaEntity in
                self.qnaInfoList.accept([qnaEntity])
                var value = self.interviewReviewInfoList.value
                value.append(
                    QnaElementRequestQuery(
                        question: qnaEntity.question,
                        answer: qnaEntity.answer,
                        codeID: self.techCode ?? 0
                    )
                )
                self.interviewReviewInfoList.accept(value)
            })
            .disposed(by: disposeBag)

        input.writableReviewButtonDidTap.asObservable()
            .flatMap {
                self.postReviewUseCase.execute(req: PostReviewRequestQuery(
                    companyID: self.companyID,
                    qnaElements: self.interviewReviewInfoList.value
                ))
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.writableReviewButtonDidTap.asObservable()
            .map { _ in WritableReviewStep.popToMyPage }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            interviewReviewInfoList: interviewReviewInfoList,
            qnaInfoList: self.qnaInfoList
        )
    }
}
