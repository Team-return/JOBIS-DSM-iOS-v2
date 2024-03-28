import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public enum CompanyDetailPopViewType {
    case searchCompany
    case recruitmentDetail
}

public final class CompanyDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var companyID: Int?
    public var recruitmentID: Int?
    public var type: CompanyDetailPopViewType = .recruitmentDetail
    private let disposeBag = DisposeBag()
    private let fetchCompanyInfoDetailUseCase: FetchCompanyInfoDetailUseCase
    private let fetchReviewListUseCase: FetchReviewListUseCase

    init(
        fetchCompanyInfoDetailUseCase: FetchCompanyInfoDetailUseCase,
        fetchReviewListUseCase: FetchReviewListUseCase
    ) {
        self.fetchCompanyInfoDetailUseCase = fetchCompanyInfoDetailUseCase
        self.fetchReviewListUseCase = fetchReviewListUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let recruitmentButtonDidTap: Signal<Void>
    }

    public struct Output {
        let companyDetailInfo: PublishRelay<CompanyInfoDetailEntity>
        let reviewListInfo: PublishRelay<[ReviewEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let companyDetailInfo = PublishRelay<CompanyInfoDetailEntity>()
        let reviewListInfo = PublishRelay<[ReviewEntity]>()

        input.viewAppear.asObservable()
            .flatMap {
                self.fetchCompanyInfoDetailUseCase.execute(id: self.companyID ?? 0)
            }
            .bind(to: companyDetailInfo)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap {
                self.fetchReviewListUseCase.execute(id: self.companyID ?? 0)
            }
            .bind(to: reviewListInfo)
            .disposed(by: disposeBag)

        input.recruitmentButtonDidTap.asObservable()
            .map { _ in
                self.type != .recruitmentDetail
                ? CompanyDetailStep.recruitmentDetailIsRequired(id: self.recruitmentID!)
                : CompanyDetailStep.popIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            companyDetailInfo: companyDetailInfo,
            reviewListInfo: reviewListInfo
        )
    }
}
