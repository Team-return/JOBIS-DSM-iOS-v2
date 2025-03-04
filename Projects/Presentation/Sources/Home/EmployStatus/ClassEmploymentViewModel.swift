import Foundation
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
        let viewWillAppear: Observable<Void>
    }

    public struct Output {
        let classInfo: Observable<ApplicationEntity>
    }

    public func transform(_ input: Input) -> Output {
        let classInfo = input.viewWillAppear
            .flatMapLatest { [fetchEmploymentStatusUseCase] in
                fetchEmploymentStatusUseCase.execute()
            }
            .map { applications in
                applications.first { $0.classId == self.classNumber } ?? ApplicationEntity(
                    applicationID: 0,
                    recruitmentID: 0,
                    company: "",
                    companyLogoUrl: "",
                    attachments: [],
                    applicationStatus: .approved,
                    classId: self.classNumber,
                    employmentRateResponseList: [],
                    totalStudents: 0,
                    passedStudents: 0
                )
            }
            .share(replay: 1)
        return Output(classInfo: classInfo)
    }
}
