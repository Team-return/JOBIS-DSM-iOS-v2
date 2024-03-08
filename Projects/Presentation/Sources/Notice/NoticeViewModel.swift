import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class NoticeViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init( ) { }

    public struct Input {
        let cellClick: PublishRelay<Void>
    }

    public struct Output { }

    public func transform(_ input: Input) -> Output {
        input.cellClick.asObservable()
            .map { _ in NoticeStep.noticeDetailIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
}
