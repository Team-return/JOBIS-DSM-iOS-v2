import Core
import Moya
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain
import Utility

public final class InfoSettingViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let studentExistsUseCase: StudentExistsUseCase

    public init(studentExistsUseCase: StudentExistsUseCase) {
        self.studentExistsUseCase = studentExistsUseCase
    }

    public struct Input {
        let name: Driver<String>
        let gcn: Driver<String>
        let nextButtonDidTap: Signal<Void>
    }
    public struct Output {
        let nameErrorDescription: PublishRelay<DescriptionType>
        let gcnErrorDescription: PublishRelay<DescriptionType>
    }

    public func transform(_ input: Input) -> Output {
        let nameErrorDescription = PublishRelay<DescriptionType>()
        let gcnErrorDescription = PublishRelay<DescriptionType>()
        let info = Driver.combineLatest(input.name, input.gcn)

        input.nextButtonDidTap
            .asObservable()
            .withLatestFrom(info)
            .avoidDuplication
            .filter { name, gcn in
                if name.isEmpty {
                    nameErrorDescription.accept(.error(description: "이름을 입력해주세요"))
                    return false
                } else if gcn.isEmpty {
                    gcnErrorDescription.accept(.error(description: "학번을 입력해주세요"))
                    return false
                }
                return true
            }
            .flatMap { [self] name, gcn in
                studentExistsUseCase.execute(
                    gcn: gcn,
                    name: name
                )
                .andThen(
                    Single.deferred {
                        gcnErrorDescription.accept(.error(description: "이미 가입 된 학번이에요."))
                        return .never()
                    }
                )
                .catch { error in
                    if let appError = error as? ApplicationsError {
                        switch appError {

                        case .conflict:
                            gcnErrorDescription.accept(.error(description: "이미 가입 된 학번이에요."))
                            return .never()

                        case .badRequest:
                            gcnErrorDescription.accept(.error(description: "학번이나 이름을 확인해주세요."))
                            return .never()

                        case .internalServerError:
                            gcnErrorDescription.accept(.error(description: "서버 오류가 발생했어요."))
                            return .never()
                        }
                    }

                    return Single.just(
                        InfoSettingStep.verifyEmailIsRequired(
                            name: name,
                            gcn: Int(gcn)!
                        )
                    )
                }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            nameErrorDescription: nameErrorDescription,
            gcnErrorDescription: gcnErrorDescription
        )
    }
}
