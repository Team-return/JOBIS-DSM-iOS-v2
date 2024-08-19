import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class BugReportViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    public var majorType = BehaviorRelay<String>(value: "전체")

    private let reportBugUseCase: ReportBugUseCase

    init(
        reportBugUseCase: ReportBugUseCase
    ) {
        self.reportBugUseCase = reportBugUseCase
    }

    public struct Input {
        let title: Driver<String>
        let content: Driver<String>
        let majorViewDidTap: PublishRelay<Void>
        let bugReportButtonDidTap: PublishRelay<(String, String, [String])>
    }

    public struct Output {
        let majorType: BehaviorRelay<String>
        let bugReportButtonIsEnable: PublishRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let bugReportButtonIsEnable = PublishRelay<Bool>()

        input.majorViewDidTap.asObservable()
            .map { _ in BugReportStep.majorBottomSheetIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.bugReportButtonDidTap.asObservable()
            .flatMap { title, content, images in
                self.reportBugUseCase.execute(req: .init(
                    title: title,
                    content: content,
                    developmentArea: DevelopmentType(rawValue: self.majorType.value.uppercased()) ?? .all,
                    attachmentUrls: images
                ))
            }
            .subscribe()
            .disposed(by: disposeBag)

        Driver.combineLatest(input.title, input.content)
            .asObservable()
            .map { new, check in
                !new.isEmpty && !check.isEmpty
            }
            .bind(to: bugReportButtonIsEnable)
            .disposed(by: disposeBag)

        return Output(
            majorType: self.majorType,
            bugReportButtonIsEnable: bugReportButtonIsEnable
        )
    }
}
