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
    public var jobCode = 0
    public var interviewType: InterviewFormat = .individual
    public var location: LocationType = .seoul
    public var interviewerCount = 1
    
    private let postReviewUseCase: PostReviewUseCase
    
    // MARK: - Reactive Properties
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
        // 질문 추가 버튼 탭 처리
        input.addQuestionButtonDidTap.asObservable()
            .map {
                WritableReviewStep.popToMyPage
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        // 새로운 QnA 추가 처리
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

        // 후기 작성 완료 버튼 탭 처리
        input.writableReviewButtonDidTap.asObservable()
            .flatMap {
                self.postReviewUseCase.execute(req: PostReviewRequestQuery(
                    interviewType: self.interviewType,
                    location: self.location,
                    companyID: self.companyID,
                    jobCode: self.jobCode,
                    interviewerCount: self.interviewerCount,
                    qnas: self.interviewReviewInfoList.value,
                    question: "", // 필요에 따라 값 설정
                    answer: ""    // 필요에 따라 값 설정
                ))
            }
            .subscribe(
                onNext: { _ in
                    // 성공 처리
                },
                onError: { error in
                    // 에러 처리
                    print("Review post failed: \(error)")
                }
            )
            .disposed(by: disposeBag)

        // 완료 후 이전 페이지로 이동
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
