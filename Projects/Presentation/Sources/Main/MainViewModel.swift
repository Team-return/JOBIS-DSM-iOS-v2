import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public class MainViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let disposeBag = DisposeBag()

    private let usecase: SendAuthCodeUseCase

    init(usecase: SendAuthCodeUseCase) {
        self.usecase = usecase
    }

    public struct Input {
        let buttonDidTap: Signal<Void>
    }

    public struct Output {
        let result: PublishRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let result = PublishRelay<Bool>()
        input.buttonDidTap.asObservable()
            .flatMap { [self] in
                usecase.execute(req: .init(email: "gtw030488@gmail.com", authCodeType: .signup))
                    .andThen(Single.just(MainStep.loginIsRequired))
                    .catch { _ in .just(MainStep.loginIsRequired) }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output(result: result)
    }
}
