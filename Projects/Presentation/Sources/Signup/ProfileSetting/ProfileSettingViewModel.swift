import Core
import UIKit
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class ProfileSettingViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    public init() {}

    private let disposeBag = DisposeBag()

    public struct Input {
        let name: String
        let gcn: Int
        let email: String
        let password: String
        let isMan: Bool
        let profileImage: UIImage
        let nextButtonDidTap: Signal<Void>
    }

    public struct Output {}

    public func transform(_ input: Input) -> Output {
//        input.nextButtonDidTap.asObservable()
//            .map { _ in
//                GenderSettingStep.genderSettingIsRequired(
//                    name: input.name,
//                    gcn: input.gcn,
//                    email: input.email,
//                    password: password
//                )
//            }
//            .bind(to: steps)
//            .disposed(by: disposeBag)
        return Output()
    }
}
