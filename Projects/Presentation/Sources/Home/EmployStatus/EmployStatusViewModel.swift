import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class EmployStatusViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase

    public init(
        fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase
    ) {
        self.fetchTotalPassStudentUseCase = fetchTotalPassStudentUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let classButtonTapped: Observable<Int>
    }

    public struct Output {
        let totalPassStudentInfo: BehaviorRelay<TotalPassStudentEntity>
    }

    public func transform(_ input: Input) -> Output {
        let totalPassStudentInfo = BehaviorRelay<TotalPassStudentEntity>(value: TotalPassStudentEntity(
            totalStudentCount: 0,
            passedCount: 0,
            approvedCount: 0
        ))

        input.viewWillAppear
            .flatMap { [self] in
                fetchTotalPassStudentUseCase.execute()
            }
            .bind(to: totalPassStudentInfo)
            .disposed(by: disposeBag)

        input.classButtonTapped
            .map { EmployStatusStep.classEmploymentIsRequired(classNumber: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            totalPassStudentInfo: totalPassStudentInfo
        )
    }
}
