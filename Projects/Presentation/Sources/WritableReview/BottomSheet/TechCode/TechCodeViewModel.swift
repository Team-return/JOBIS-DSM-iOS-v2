import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class TechCodeViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init() {

    }

    public struct Input {
//        let viewWillAppear: PublishRelay<Void>
        let addReviewButtonDidTap: PublishRelay<Void>
    }

    public struct Output {
        
    }

    public func transform(_ input: Input) -> Output {
        input.addReviewButtonDidTap.asObservable()
            .map { TechCodeStep.popToWritableReview }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
}
