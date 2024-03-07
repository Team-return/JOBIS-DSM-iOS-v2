import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class CompanyDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init( ) { }

    public struct Input {
        let recruitmentButtonDidClicked: Signal<Void>
    }

    public struct Output { }

    public func transform(_ input: Input) -> Output {
        input.recruitmentButtonDidClicked.asObservable()
            .map { _ in CompanyDetailStep.recruitmentDetailIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
}
