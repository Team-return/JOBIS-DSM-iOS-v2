import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class HomeViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase
    private let fetchApplicationUseCase: FetchApplicationUseCase

    init(
        fetchStudentInfoUseCase: FetchStudentInfoUseCase,
        fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase,
        fetchApplicationUseCase: FetchApplicationUseCase
    ) {
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        self.fetchTotalPassStudentUseCase = fetchTotalPassStudentUseCase
        self.fetchApplicationUseCase = fetchApplicationUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let navigateToAlarmButtonDidTap: Signal<Void>
    }

    public struct Output {
        let studentInfo: PublishRelay<StudentInfoEntity>
        let employmentPercentage: PublishRelay<TotalPassStudentEntity>
        let applicationList: PublishRelay<[ApplicationEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let studentInfo = PublishRelay<StudentInfoEntity>()
        let employmentPercentage = PublishRelay<TotalPassStudentEntity>()
        let applicationList = PublishRelay<[ApplicationEntity]>()

        input.viewAppear.asObservable()
            .flatMap { [self] in
                fetchStudentInfoUseCase.execute()
            }
            .bind(to: studentInfo)
            .disposed(by: disposeBag)

        input.navigateToAlarmButtonDidTap.asObservable()
            .map { _ in
                HomeStep.alarmIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap { [self] in
                fetchTotalPassStudentUseCase.execute()
            }
            .bind(to: employmentPercentage)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap { [self] in
                fetchApplicationUseCase.execute()
            }
            .bind(to: applicationList)
            .disposed(by: disposeBag)

        return Output(
            studentInfo: studentInfo,
            employmentPercentage: employmentPercentage,
            applicationList: applicationList
        )
    }
}
