import Foundation
import Core
import RxSwift
import RxCocoa
import Domain
import RxFlow

public final class ClassEmploymentViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchEmploymentStatusUseCase: FetchEmploymentStatusUseCase
    private let classNumber: Int

    public init(
        fetchEmploymentStatusUseCase: FetchEmploymentStatusUseCase,
        classNumber: Int
    ) {
        self.fetchEmploymentStatusUseCase = fetchEmploymentStatusUseCase
        self.classNumber = classNumber
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
    }

    public struct Output {
        let classInfo: Driver<EmploymentEntity>
    }

    public func transform(_ input: Input) -> Output {
        let classInfo = input.viewAppear
            .flatMapLatest { [fetchEmploymentStatusUseCase, classNumber] in
                let currentYear = Calendar.current.component(.year, from: Date())
                return fetchEmploymentStatusUseCase.execute(year: currentYear)
                    .asObservable()
                    .map { employments in
                        employments.first { $0.classID == classNumber } ??
                        EmploymentEntity.empty.with(classID: classNumber)
                    }
                    .catchAndReturn(.empty)
            }
            .asDriver(onErrorJustReturn: .empty)

        return Output(
            classInfo: classInfo
        )
    }
}
