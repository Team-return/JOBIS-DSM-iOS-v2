import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ReviewDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    public var reviewID: Int?

    public struct Input {}
    public struct Output {}

    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
