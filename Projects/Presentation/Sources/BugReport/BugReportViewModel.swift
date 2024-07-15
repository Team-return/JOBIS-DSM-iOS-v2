import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class BugReportViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public struct Input {
        let majorViewDidTap: PublishRelay<Void>
    }

    public struct Output {}

    public func transform(_ input: Input) -> Output {
        input.majorViewDidTap.asObservable()
            .map { _ in BugReportStep.majorBottomSheetIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output()
    }
}
