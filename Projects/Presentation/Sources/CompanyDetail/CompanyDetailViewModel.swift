import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class CompanyDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var companyID: Int?
    private let disposeBag = DisposeBag()
    private let fetchCompanyInfoDetailUseCase: FetchCompanyInfoDetailUseCase

    init(
        fetchCompanyInfoDetailUseCase: FetchCompanyInfoDetailUseCase,
    ) {
        self.fetchCompanyInfoDetailUseCase = fetchCompanyInfoDetailUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let recruitmentButtonDidTap: Signal<Void>
    }

    public struct Output {
        let companyDetailInfo: PublishRelay<CompanyInfoDetailEntity>
    }

    public func transform(_ input: Input) -> Output {
        let companyDetailInfo = PublishRelay<CompanyInfoDetailEntity>()
        input.viewAppear.asObservable()
            .flatMap {
                self.fetchCompanyInfoDetailUseCase.execute(id: self.companyID ?? 0)
            }
            .bind(to: companyDetailInfo)
            .disposed(by: disposeBag)
        input.recruitmentButtonDidTap.asObservable()
            .map { _ in CompanyDetailStep.recruitmentDetailIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            companyDetailInfo: companyDetailInfo,
        )
    }
}
