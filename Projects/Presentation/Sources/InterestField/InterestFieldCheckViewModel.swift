import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class InterestFieldCheckViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let studentNameRelay = BehaviorRelay<String>(value: "")

    public init(fetchStudentInfoUseCase: FetchStudentInfoUseCase) {
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
//        let backButtonTap: Observable<Void>
    }

    public struct Output {
        let studentName: Driver<String>
    }

    public func transform(_ input: Input) -> Output {
        input.viewWillAppear
            .flatMapLatest { [unowned self] in
                self.fetchStudentInfoUseCase.execute().asObservable()
            }
            .map { $0.studentName }
            .bind(to: studentNameRelay)
            .disposed(by: disposeBag)

//        input.backButtonTap
//            .map { InterestFieldCheckStep.popHomeFieldIsRequired }
//            .bind(to: steps)
//            .disposed(by: disposeBag)

        return Output(
            studentName: studentNameRelay.asDriver()
        )
    }
}
