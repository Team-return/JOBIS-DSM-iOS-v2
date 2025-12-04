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
    private let year: Int

    public init(
        fetchEmploymentStatusUseCase: FetchEmploymentStatusUseCase,
        classNumber: Int,
        year: Int
    ) {
        self.fetchEmploymentStatusUseCase = fetchEmploymentStatusUseCase
        self.classNumber = classNumber
        self.year = year
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
    }

    public struct Output {
        let classInfo: Driver<EmploymentEntity>
    }

    public func transform(_ input: Input) -> Output {
        let classInfo = input.viewAppear
            .flatMapLatest { [fetchEmploymentStatusUseCase, classNumber, year] in
                return fetchEmploymentStatusUseCase.execute(year: year)
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
