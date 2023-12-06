import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class HomeViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let disposeBag = DisposeBag()

    private let signinUseCase: SigninUseCase
    private let reissueTokenUseCase: ReissueTokenUaseCase

    init(signinUseCase: SigninUseCase, reissueTokenUseCase: ReissueTokenUaseCase) {
        self.signinUseCase = signinUseCase
        self.reissueTokenUseCase = reissueTokenUseCase
    }

    public struct Input {
        let signinButtonDidTap: Signal<Void>
        let reissueButtonDidTap: Signal<Void>
    }

    public struct Output {
        let string: PublishRelay<String>
        let result: PublishRelay<Bool>
        let isLoading: BehaviorRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let string = PublishRelay<String>()
        let result = PublishRelay<Bool>()
        let isLoading: BehaviorRelay<Bool> = .init(value: false)
        input.signinButtonDidTap.asObservable()
            .flatMap { [self] in
                isLoading.accept(true)
                return signinUseCase.execute(
                    req: .init(
                        accountID: "test@dsm.hs.kr",
                        password: "student"
                    )
                )
                .do(
                    onSuccess: {
                    string.accept($0.rawValue)
                    print($0)
                    isLoading.accept(false)
                    }, onError: { _ in
                        isLoading.accept(false)
                    }
                )
                .asCompletable()
//                .andThen(Single.just(MainStep.loginIsRequired))
            }
            .subscribe(onCompleted: .none)
            .disposed(by: disposeBag)

        input.reissueButtonDidTap.asObservable()
            .flatMap { [self] in
                isLoading.accept(true)
                return reissueTokenUseCase.execute()
                    .do(
                        onSuccess: {
                            string.accept($0.rawValue)
                            print($0)
                            isLoading.accept(false)
                        }, onError: { _ in
                            isLoading.accept(false)
                        }
                    )
                    .asCompletable()
//                .andThen(Single.just(MainStep.loginIsRequired))
            }
            .subscribe(onCompleted: .none)
            .disposed(by: disposeBag)
        return Output(string: string, result: result, isLoading: isLoading)
    }
}
