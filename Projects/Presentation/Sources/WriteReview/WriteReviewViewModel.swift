import Core
import DesignSystem
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class WriteReviewViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public struct Input {
    }

    public struct Output {
    }

    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
