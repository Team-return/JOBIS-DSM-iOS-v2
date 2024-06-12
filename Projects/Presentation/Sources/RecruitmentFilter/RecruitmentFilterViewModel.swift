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
    public let techCode = BehaviorRelay<[String]>(value: [])

    init(
        fetchCodeListUseCase: FetchCodeListUseCase
    ) {
        self.fetchCodeListUseCase = fetchCodeListUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let selectJobsCode: Observable<CodeEntity>
        let filterApplyButtonDidTap: PublishRelay<Void>
        let appendTechCode: PublishRelay<String>
        let resetTechCode: PublishRelay<Void>
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
            .do(onNext: {
                self.jobCode = self.jobCode == "\($0.code)" ? "" : "\($0.code)"
                jobList.accept(jobList.value)
            })
            .flatMap { _ in
                self.fetchCodeListUseCase.execute(keyword: nil, type: .tech, parentCode: self.jobCode)
            }
            .bind(to: techList)
            .disposed(by: disposeBag)

        input.filterApplyButtonDidTap.asObservable()
            .map {
                return RecruitmentFilterStep.popToRecruitment(
                    jobCode: self.jobCode,
                    techCode: self.techCode.value
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.appendTechCode.asObservable()
            .filter { $0 != "" }
            .bind {
                var value = self.techCode.value
                value.append($0)
                self.techCode.accept(value)
            }
            .disposed(by: disposeBag)

        input.resetTechCode.asObservable()
            .bind {
                self.techCode.accept([])
            }
            .disposed(by: disposeBag)

        return Output(jobList: jobList, techList: techList)
    }
}
