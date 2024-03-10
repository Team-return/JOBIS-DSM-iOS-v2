import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    private let fetchRecruitmentDetailUseCase: FetchRecruitmentDetailUseCase

    init(
        fetchRecruitmentDetailUseCase: FetchRecruitmentDetailUseCase
    ) {
        self.fetchRecruitmentDetailUseCase = fetchRecruitmentDetailUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let companyDetailButtonDidClicked: Signal<Void>
    }

    public struct Output {
        let recruitmentDetailInfo: PublishRelay<RecruitmentDetailEntity>
    }

    public func transform(_ input: Input) -> Output {
        let recruitmentDetailInfo = PublishRelay<RecruitmentDetailEntity>()

        input.viewAppear.asObservable()
            .flatMap {
                self.fetchRecruitmentDetailUseCase.execute(id: RecruitmentDetailViewController.companyID)
            }
            .bind(to: recruitmentDetailInfo)
            .disposed(by: disposeBag)

        input.companyDetailButtonDidClicked.asObservable()
            .map { _ in RecruitmentDetailStep.companyDetailIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(recruitmentDetailInfo: recruitmentDetailInfo)
    }
}
