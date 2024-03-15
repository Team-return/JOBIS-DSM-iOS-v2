import Core
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class ApplyViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    public init() {}

    private let disposeBag = DisposeBag()

    public struct Input {}
    public struct Output {}

    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
