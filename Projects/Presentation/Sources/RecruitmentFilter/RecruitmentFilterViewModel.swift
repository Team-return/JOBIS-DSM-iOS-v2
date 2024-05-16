import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentFilterViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchCodeListUseCase: FetchCodeListUseCase
    public var jobCode: String = ""
    public var techCode: String = ""

    init(
        fetchCodeListUseCase: FetchCodeListUseCase
    ) {
        self.fetchCodeListUseCase = fetchCodeListUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let selectJobsCode: PublishRelay<Void>
        let filterApplyButtonDidTap: PublishRelay<Void>
    }

    public struct Output {
        let jobList: BehaviorRelay<[CodeEntity]>
        let techList: BehaviorRelay<[CodeEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let jobList = BehaviorRelay<[CodeEntity]>(value: [])
        let techList = BehaviorRelay<[CodeEntity]>(value: [])
        input.viewWillAppear.asObservable()
            .flatMap {
                self.fetchCodeListUseCase.execute(keyword: nil, type: .job, parentCode: nil)
            }
            .bind(to: jobList)
            .disposed(by: disposeBag)

        input.viewWillAppear.asObservable()
            .flatMap {
                self.fetchCodeListUseCase.execute(keyword: nil, type: .tech, parentCode: nil)
            }
            .bind(to: techList)
            .disposed(by: disposeBag)

        input.selectJobsCode.asObservable()
            .flatMap {
                self.fetchCodeListUseCase.execute(keyword: self.jobCode, type: .tech, parentCode: nil)
            }
            .bind(to: techList)
            .disposed(by: disposeBag)

        input.filterApplyButtonDidTap.asObservable()
            .map {
                print("------------------ Filter viewModel! ---------------------")
                dump(self.jobCode)
                dump(self.techCode)
                print("------------------ ------- --------- ---------------------")
                return RecruitmentFilterStep.popToRecruitment(
                    jobCode: self.jobCode,
                    techCode: self.techCode
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(jobList: jobList, techList: techList)
    }
}
