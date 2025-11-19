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
        let applyButtonDidTap: Signal<Void>
    }

    public struct Output {
    }

    public func transform(_ input: Input) -> Output {
        input.applyButtonDidTap
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(EmployStatusStep.popEmploymentFilter)
            })
            .disposed(by: disposeBag)

        return Output()
    }
}
