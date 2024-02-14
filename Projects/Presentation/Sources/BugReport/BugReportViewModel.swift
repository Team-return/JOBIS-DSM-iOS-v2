import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class BugReportViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public struct Input {}

    public struct Output {}

    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
