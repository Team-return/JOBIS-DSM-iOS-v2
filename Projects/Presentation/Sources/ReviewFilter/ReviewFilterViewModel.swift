import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ReviewFilterViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchCodeListUseCase: FetchCodeListUseCase
    public var jobCode: String = ""
    public var selectedYear: String = ""

    init(
        fetchCodeListUseCase: FetchCodeListUseCase
    ) {
        self.fetchCodeListUseCase = fetchCodeListUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let selectJobsCode: Observable<CodeEntity>
        let selectYear: Observable<String>
        let filterApplyButtonDidTap: PublishRelay<Void>
    }
    public struct Output {
        let jobList: BehaviorRelay<[CodeEntity]>
        let interviewTypeList: BehaviorRelay<[CodeEntity]>
        let regionList: BehaviorRelay<[CodeEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let jobList = BehaviorRelay<[CodeEntity]>(value: [])
        let interviewTypeList = BehaviorRelay<[CodeEntity]>(value: [])
        let regionList = BehaviorRelay<[CodeEntity]>(value: [])
        input.viewWillAppear.asObservable()
            .flatMap {
                self.fetchCodeListUseCase.execute(keyword: nil, type: .job, parentCode: nil)
            }
            .bind(to: jobList)
            .disposed(by: disposeBag)

        input.viewWillAppear.asObservable()
            .map { _ in
                [
                    CodeEntity(code: 1, keyword: "개인 면접"),
                    CodeEntity(code: 2, keyword: "단체 면접"),
                    CodeEntity(code: 3, keyword: "기타 면접")
                ]
            }
            .bind(to: interviewTypeList)
            .disposed(by: disposeBag)

        input.viewWillAppear.asObservable()
            .map { _ in
                [
                    CodeEntity(code: 1, keyword: "대전"),
                    CodeEntity(code: 2, keyword: "서울"),
                    CodeEntity(code: 3, keyword: "경기"),
                    CodeEntity(code: 4, keyword: "기타")
                ]
            }
            .bind(to: regionList)
            .disposed(by: disposeBag)

        input.selectJobsCode.asObservable()
            .bind { [weak self] code in
                self!.jobCode = self!.jobCode == "\(code)" ? "" : "\(code)"
            }
            .disposed(by: disposeBag)

        input.selectYear.asObservable()
            .bind { [weak self] year in
                self?.selectedYear = year
            }
            .disposed(by: disposeBag)

        input.filterApplyButtonDidTap.asObservable()
            .map {
                ReviewFilterStep.popToReview(
                    jobCode: self.jobCode
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            jobList: jobList,
            interviewTypeList: interviewTypeList,
            regionList: regionList
        )
    }
}
