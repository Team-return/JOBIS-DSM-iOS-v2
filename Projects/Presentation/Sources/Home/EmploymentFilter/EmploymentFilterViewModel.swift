import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Core

public final class EmploymentFilterViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    public var currentYear: Int = Calendar.current.component(.year, from: Date())

    public init() {
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let applyButtonDidTap: Signal<Int>
    }

    public struct Output {
    }

    public func transform(_ input: Input) -> Output {
        input.applyButtonDidTap
            .asObservable()
            .subscribe(onNext: { [weak self] year in
                self?.steps.accept(EmployStatusStep.applyYearFilter(year: year))
            })
            .disposed(by: disposeBag)

        return Output()
    }
}
