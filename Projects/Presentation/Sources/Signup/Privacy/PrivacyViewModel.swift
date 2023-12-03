import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public final class PrivacyViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let disposeBag = DisposeBag()

    private let signupUseCase: SignupUseCase

    init(signupUseCase: SignupUseCase) {
        self.signupUseCase = signupUseCase
    }

    public struct Input {
        let signupButtonDidTap: Signal<Void>
    }
    public struct Output { }

    public func transform(_ input: Input) -> Output {
        input.signupButtonDidTap
            .asObservable()
            .flatMap { [self] in
                try signupUseCase.execute(req: SignupUserInfo.toQuery())
                    .catch { _ in
                        return .never()
                    }
                    .do(onCompleted: {
                        SignupUserInfo.removeInfo()
                    })
                    .andThen(Single.just(PrivacyStep.tabsIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output()
    }
}
