import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Core

public final class EmploymentFilterViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public init() {
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
    }

    public struct Output {
    }

    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
