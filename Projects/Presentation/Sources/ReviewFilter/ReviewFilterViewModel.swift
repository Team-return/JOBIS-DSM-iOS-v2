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
    public var code: String = ""
    public var years: [String] = []
    public var type: String = ""
    public var location: String = ""

    init(
        fetchCodeListUseCase: FetchCodeListUseCase
    ) {
        self.fetchCodeListUseCase = fetchCodeListUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let selectJobsCode: Observable<CodeEntity>
        let selectYear: Observable<[String]>
        let selectInterviewType: Observable<CodeEntity>
        let selectLocation: Observable<CodeEntity>
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
                InterviewFormat.allCases.map { format in
                    CodeEntity(code: format.rawValue.hashValue, keyword: format.rawValue)
                }
            }
            .bind(to: interviewTypeList)
            .disposed(by: disposeBag)

        input.viewWillAppear.asObservable()
            .map { _ in
                LocationType.allCases.map { location in
                    CodeEntity(code: location.rawValue.hashValue, keyword: location.rawValue)
                }
            }
            .bind(to: regionList)
            .disposed(by: disposeBag)

        input.selectJobsCode.asObservable()
            .bind { [weak self] code in
                self?.code = String(code.code)
            }
            .disposed(by: disposeBag)

        input.selectYear.asObservable()
            .bind { [weak self] years in
                self?.years = years
            }
            .disposed(by: disposeBag)

        input.selectInterviewType.asObservable()
            .bind { [weak self] code in
                self?.type = code.keyword
            }
            .disposed(by: disposeBag)

        input.selectLocation.asObservable()
            .bind { [weak self] code in
                self?.location = code.keyword
            }
            .disposed(by: disposeBag)

        input.filterApplyButtonDidTap.asObservable()
            .map {
                ReviewFilterStep.popToReview(
                    code: self.code,
                    year: self.years,
                    type: self.type,
                    location: self.location
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
