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
    public var status: String = ""
    public var years = BehaviorRelay<[String]>(value: [])
    public let techCode = BehaviorRelay<[String]>(value: [])

    init(
        fetchCodeListUseCase: FetchCodeListUseCase
    ) {
        self.fetchCodeListUseCase = fetchCodeListUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let selectJobsCode: Observable<CodeEntity>
        let selectYears: Observable<CodeEntity>
        let selectStatus: Observable<CodeEntity>
        let filterApplyButtonDidTap: PublishRelay<Void>
        let appendTechCode: PublishRelay<CodeEntity>
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

        input.selectYears.asObservable()
            .bind { code in
                let yearString = "\(code.code)"
                var selected = self.years.value
                if let index = selected.firstIndex(of: yearString) {
                    selected.remove(at: index)
                } else {
                    selected.append(yearString)
                }
                self.years.accept(selected)
            }
            .disposed(by: disposeBag)

        input.selectStatus.asObservable()
            .bind { code in
                let mappedStatus = self.mapStatus(code: code.code)
                if self.status == mappedStatus {
                    self.status = ""
                } else {
                    self.status = mappedStatus
                }
            }
            .disposed(by: disposeBag)

        input.filterApplyButtonDidTap.asObservable()
            .map {
                RecruitmentFilterStep.popToRecruitment(
                    jobCode: self.jobCode,
                    techCode: self.techCode.value,
                    years: self.years.value,
                    status: self.status
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.appendTechCode.asObservable()
            .filter { "\($0.code)" != "" }
            .bind {
                var value = self.techCode.value
                value.append("\($0.code)")
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

extension RecruitmentFilterViewModel {
    public func mapStatus(code: Int) -> String {
        switch code {
        case 0:
            return "RECRUITING"
        case 1:
            return "DONE"
        default:
            return ""
        }
    }
}
