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
    public var companyName: String = ""
    public var jobCode = 0
    public var interviewType: InterviewFormat = .individual
    public var location: LocationType = .seoul
    public var interviewerCount = 1
    private let postReviewUseCase: PostReviewUseCase
    public var interviewReviewInfo = PublishRelay<QnAEntity>()
    public var qnaInfoList = PublishRelay<[QnAEntity]>()
    public var interviewReviewInfoList = BehaviorRelay<[QnaRequestQuery]>(value: [])

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
        let interviewReviewInfoList: BehaviorRelay<[QnaRequestQuery]>
        let qnaInfoList: PublishRelay<[QnAEntity]>
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
                    QnaRequestQuery(
                        questionID: qnaEntity.id,
                        answer: qnaEntity.answer
                    )
                )
                self.interviewReviewInfoList.accept(value)
            })
            .disposed(by: disposeBag)

        input.writableReviewButtonDidTap.asObservable()
            .flatMap {
                self.postReviewUseCase.execute(req: PostReviewRequestQuery(
                    interviewType: self.interviewType,
                    location: self.location,
                    companyID: self.companyID,
                    jobCode: self.jobCode,
                    interviewerCount: self.interviewerCount,
                    qnas: self.interviewReviewInfoList.value,
                    question: "",
                    answer: ""
                ))
            }
            .subscribe(
                onNext: { _ in
                },
                onError: { error in
                    print("Review post failed: \(error)")
                }
            )
            .disposed(by: disposeBag)

        input.writableReviewButtonDidTap.asObservable()
            .map { _ in WritableReviewStep.addReviewIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            interviewReviewInfoList: interviewReviewInfoList,
            qnaInfoList: self.qnaInfoList
        )
    }
}
