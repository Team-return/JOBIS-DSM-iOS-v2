import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public final class PrivacyViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let signupUseCase: SignupUseCase

    public init(signupUseCase: SignupUseCase) {
        self.signupUseCase = signupUseCase
    }

    public struct Input {
        let name: String
        let gcn: Int
        let email: String
        let password: String
        let signupButtonDidTap: Signal<Void>
    }
    public struct Output {}

    public func transform(_ input: Input) -> Output {
        input.signupButtonDidTap
            .asObservable()
            .flatMap { [self] in
                signupUseCase.execute(
                    req: .init(
                        email: input.email.dsmEmail(),
                        password: input.password,
                        grade: input.gcn.extract(4),
                        name: input.name,
                        gender: .man,
                        classRoom: input.gcn.extract(3),
                        number: input.gcn % 100
                    )
                )
                .catch { _ in .never() }
                .andThen(Single.just(PrivacyStep.tabsIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
}
