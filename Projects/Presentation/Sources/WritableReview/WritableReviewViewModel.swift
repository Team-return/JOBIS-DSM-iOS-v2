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

    public var interviewReviewInfo = PublishRelay<QnAEntity>()
    public var qnaInfoList = BehaviorRelay<[QnAEntity]>(value: [])

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let addQuestionButtonDidTap: PublishRelay<Void>
    }

    public struct Output {
        let qnaInfoList: BehaviorRelay<[QnAEntity]>
    }

    public func transform(_ input: Input) -> Output {
        input.addQuestionButtonDidTap.asObservable()
            .map {
                WritableReviewStep.addReviewIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        self.interviewReviewInfo.asObservable()
            .withLatestFrom(qnaInfoList) { ($0, $1) }
            .map { newInfo, oldList -> [QnAEntity] in
                var newList = oldList
                newList.append(newInfo)
                return newList
            }
            .bind(to: qnaInfoList)
            .disposed(by: disposeBag)

        return Output(
            qnaInfoList: self.qnaInfoList
        )
    }
}
