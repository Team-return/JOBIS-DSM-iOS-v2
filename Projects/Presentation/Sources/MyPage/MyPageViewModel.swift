import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public class MyPageViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase

    init(fetchStudentInfoUseCase: FetchStudentInfoUseCase) {
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
    }

    private let disposeBag = DisposeBag()

    public struct Input {
        let viewAppear: PublishRelay<Void>
    }

    public struct Output {
        let studentInfo: PublishRelay<StudentInfoEntity>
    }

    public func transform(_ input: Input) -> Output {
        let studentInfo = PublishRelay<StudentInfoEntity>()
        input.viewAppear.asObservable()
            .flatMap { self.fetchStudentInfoUseCase.execute() }
            .bind(to: studentInfo)
            .disposed(by: disposeBag)
        return Output(studentInfo: studentInfo)
    }
}
