import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class AddReviewViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init() { }

    public struct Input {
//        let viewWillAppear: PublishRelay<Void>
    }

    public struct Output {

    }

    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
