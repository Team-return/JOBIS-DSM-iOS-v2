import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class MajorBottomSheetViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
//    private let list: [String] = ["iOS", "Android", "Server", "Web", "전체"]

    public struct Input {}

    public struct Output {
//        let list: [String]
    }

    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
