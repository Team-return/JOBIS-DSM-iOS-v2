import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public enum CompanyDetailPreviousViewType {
    case searchCompany
    case recruitmentDetail
}

public final class CompanyDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var companyID: Int?
    public var recruitmentID: Int?
    public var type: CompanyDetailPreviousViewType = .recruitmentDetail
    private let disposeBag = DisposeBag()
    private let fetchCompanyInfoDetailUseCase: FetchCompanyInfoDetailUseCase
    private let fetchReviewListUseCase: FetchReviewListCountUseCase

    init(
        fetchCompanyInfoDetailUseCase: FetchCompanyInfoDetailUseCase,
        fetchReviewListUseCase: FetchReviewListCountUseCase
    ) {
        self.fetchCompanyInfoDetailUseCase = fetchCompanyInfoDetailUseCase
        self.fetchReviewListUseCase = fetchReviewListUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let recruitmentButtonDidTap: Signal<Void>
        let interviewReviewTableViewDidTap: Observable<(Int, String)>
    }

    public struct Output {
        let companyDetailInfo: PublishRelay<CompanyInfoDetailEntity>
        let reviewListPageCount: PublishRelay<Int>
    }

    public func transform(_ input: Input) -> Output {
        let companyDetailInfo = PublishRelay<CompanyInfoDetailEntity>()
        let reviewListPageCount = PublishRelay<Int>()

        input.viewAppear.asObservable()
            .flatMap {
                self.fetchCompanyInfoDetailUseCase.execute(id: self.companyID ?? 0)
            }
            .bind(to: companyDetailInfo)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap {
                self.fetchReviewListUseCase.execute(companyID: self.companyID)
            }
            .bind(to: reviewListPageCount)
            .disposed(by: disposeBag)

        input.recruitmentButtonDidTap.asObservable()
            .map { _ in
                self.type != .recruitmentDetail
                ? CompanyDetailStep.recruitmentDetailIsRequired(id: self.recruitmentID!)
                : CompanyDetailStep.popIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.interviewReviewTableViewDidTap.asObservable()
            .map { id, name in
                CompanyDetailStep.interviewReviewDetailIsRequired(id: id, name: name)
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output(
            companyDetailInfo: companyDetailInfo,
            reviewListPageCount: reviewListPageCount
        )
    }
}
