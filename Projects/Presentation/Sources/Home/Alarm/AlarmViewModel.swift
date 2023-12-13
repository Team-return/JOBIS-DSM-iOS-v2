import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class AlarmViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let disposeBag = DisposeBag()

//    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
//
//    init(
//        fetchStudentInfoUseCase: FetchStudentInfoUseCase
//    ) {
//        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
//    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
    }

    public struct Output {}

    public func transform(_ input: Input) -> Output {
        return Output()
    }
}
