import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public final class InfoSettingViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let studentExistsUseCase: StudentExistsUseCase

    init(studentExistsUseCase: StudentExistsUseCase) {
        self.studentExistsUseCase = studentExistsUseCase
    }

    private let disposeBag = DisposeBag()
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
            .filter { name, gcn in
                if name.isEmpty {
                    nameErrorDescription.accept(.error(description: "빈칸을 채워주세요"))
                    return false
                } else if gcn.isEmpty {
                    gcnErrorDescription.accept(.error(description: "빈칸을 채워주세요"))
                    return false
                }
                return true
            }
            .flatMap { [self] name, gcn in
                studentExistsUseCase.execute(
                    gcn: gcn,
                    name: name
                )
                .catch { _ in
                    gcnErrorDescription.accept(.error(description: "잘못된 학번이에요."))
                    nameErrorDescription.accept(.error(description: "잘못된 이름이에요."))
                    return .never()
                }
                .andThen(Single.just(InfoSettingStep.verifyEmailIsRequired(name: name, gcn: Int(gcn)!)))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            nameErrorDescription: nameErrorDescription,
            gcnErrorDescription: gcnErrorDescription
        )
    }
}
