import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class MajorBottomSheetViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    public var majorType = BehaviorRelay<String>(value: "전체")

    public struct Input {
        let majorTypeStackViewDidTap: PublishRelay<Void>
    }

    public struct Output { }

    public func transform(_ input: Input) -> Output {
        input.majorTypeStackViewDidTap.asObservable()
            .map { MajorBottomSheetStep.dismissToBugReport }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
}
