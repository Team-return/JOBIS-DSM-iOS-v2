import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class EmployStatusViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    public init() {}
    public struct Input {}
    public struct Output {}
    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
