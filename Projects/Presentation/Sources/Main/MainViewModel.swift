import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core

public class MainViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    public struct Input {
        let ButtonDidTap: Signal<Void>
    }
    
    public struct Output {
        let result: PublishRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let result = PublishRelay<Bool>()
        input.ButtonDidTap.asObservable()
            .map { MainStep.loginIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output(result: result)
    }
    public init() { }
}
