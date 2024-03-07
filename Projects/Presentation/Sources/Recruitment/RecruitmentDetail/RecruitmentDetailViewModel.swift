import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init( ) { }

    public struct Input {
        let companyDetailButtonDidClicked: Signal<Void>
    }

    public struct Output { }

    public func transform(_ input: Input) -> Output {
        input.companyDetailButtonDidClicked.asObservable()
            .map { _ in RecruitmentDetailStep.companyDetailIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output()
    }
}
