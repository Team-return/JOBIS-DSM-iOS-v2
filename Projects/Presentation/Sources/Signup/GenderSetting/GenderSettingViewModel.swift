import Core
import Domain
import RxFlow
import RxSwift
import RxCocoa
import Utility

public final class GenderSettingViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    public init() {}

    private let disposeBag = DisposeBag()

    public struct Input {
        let name: String
        let gcn: Int
        let email: String
        let password: String
        let gender: Signal<GenderType>
        let nextButtonDidTap: Signal<Void>
    }

    public struct Output {}

    public func transform(_ input: Input) -> Output {
        input.nextButtonDidTap.asObservable()
            .withLatestFrom(input.gender)
            .avoidDuplication
            .map { gender in
                GenderSettingStep.profileSettingIsRequired(
                    name: input.name,
                    gcn: input.gcn,
                    email: input.email,
                    password: input.password,
                    isMan: gender == .man
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output()
    }
}
