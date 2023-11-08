import Core
import RxFlow
import RxSwift
import RxCocoa

public final class SigninViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let disposeBag = DisposeBag()
    public struct Input { }
    public struct Output { }

    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
