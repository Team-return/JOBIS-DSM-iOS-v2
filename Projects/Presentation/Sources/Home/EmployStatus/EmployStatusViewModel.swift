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
    private let selectedYearRelay = BehaviorRelay<Int>(value: Calendar.current.component(.year, from: Date()))
    private var totalPassStudentInfoRelay: BehaviorRelay<TotalPassStudentEntity>?

    public init(
        fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase
    ) {
        self.fetchTotalPassStudentUseCase = fetchTotalPassStudentUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let classButtonTapped: Observable<Int>
        let filterButtonDidTap: Signal<Void>
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
        self.totalPassStudentInfoRelay = totalPassStudentInfo

        Observable.merge(
            input.viewWillAppear.map { _ in () },
            selectedYearRelay.skip(1).map { _ in () }
        )
        .withLatestFrom(selectedYearRelay)
        .flatMap { [self] year in
            fetchTotalPassStudentUseCase.execute(year: year)
        }
        .bind(to: totalPassStudentInfo)
        .disposed(by: disposeBag)

        input.classButtonTapped
            .map { EmployStatusStep.classEmploymentIsRequired(classNumber: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.filterButtonDidTap
            .asObservable()
            .map { EmployStatusStep.employmentFilterIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            totalPassStudentInfo: totalPassStudentInfo
        )
    }

    public func updateYear(_ year: Int) {
        selectedYearRelay.accept(year)
    }
}
