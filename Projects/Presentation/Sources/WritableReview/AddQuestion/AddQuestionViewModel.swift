import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class AddQuestionViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let postReviewUseCase: PostReviewUseCase

    private let companyID: Int
    private let interviewType: InterviewFormat
    private let location: LocationType
    private let jobCode: Int
    private let interviewerCount: Int
    private var qnas: [QnaRequestQuery]

    public init(
        postReviewUseCase: PostReviewUseCase,
        companyID: Int,
        interviewType: InterviewFormat,
        location: LocationType,
        jobCode: Int,
        interviewerCount: Int,
        qnas: [QnaRequestQuery]
    ) {
        self.postReviewUseCase = postReviewUseCase
        self.companyID = companyID
        self.interviewType = interviewType
        self.location = location
        self.jobCode = jobCode
        self.interviewerCount = interviewerCount
        self.qnas = qnas
    }

    public struct Input {
        let questionText: Driver<String>
        let answerText: Driver<String>
        let nextButtonDidTap: Signal<Void>
    }

    public struct Output {
        let isNextButtonEnabled: Driver<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let info = Driver.combineLatest(input.questionText, input.answerText)
        let isNextButtonEnabled = info.map { !$0.0.isEmpty && !$0.1.isEmpty }

        input.nextButtonDidTap.asObservable()
            .withLatestFrom(info)
            .flatMap { [weak self] question, answer -> Single<Step> in
                guard let self, !question.isEmpty, !answer.isEmpty else { return .never() }

                let req = PostReviewRequestQuery(
                    interviewType: self.interviewType,
                    location: self.location,
                    companyID: self.companyID,
                    jobCode: self.jobCode,
                    interviewerCount: self.interviewerCount,
                    qnas: self.qnas,
                    question: question,
                    answer: answer
                )
                return self.postReviewUseCase.execute(req: req)
                    .andThen(Single.just(WritableReviewStep.popToMyPage))
                    .catch { error in
                        print("Error posting review: \(error)")
                        return .never()
                    }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(isNextButtonEnabled: isNextButtonEnabled)
    }
}
