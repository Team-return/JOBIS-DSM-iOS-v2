import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var recruitmentID: Int?
    public var companyId: Int?
    private let disposeBag = DisposeBag()

    private let fetchRecruitmentDetailUseCase: FetchRecruitmentDetailUseCase
    private let bookmarkUseCase: BookmarkUseCase

    init(
        fetchRecruitmentDetailUseCase: FetchRecruitmentDetailUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.fetchRecruitmentDetailUseCase = fetchRecruitmentDetailUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let companyDetailButtonDidClicked: Signal<Void>
        let bookMarkButtonDidTap: Signal<Void>
        let applyButtonDidTap: Signal<Void>
    }

    public struct Output {
        let recruitmentDetailEntity: PublishRelay<RecruitmentDetailEntity>
        let areaListEntity: BehaviorRelay<[AreaEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let recruitmentDetailEntity = PublishRelay<RecruitmentDetailEntity>()
        let areaListEntity = BehaviorRelay<[AreaEntity]>(value: [])

        input.viewAppear.asObservable()
            .flatMap {
                self.fetchRecruitmentDetailUseCase.execute(id: self.recruitmentID ?? 0)
            }
            .bind {
                recruitmentDetailEntity.accept($0)
                areaListEntity.accept($0.areas)
            }
            .disposed(by: disposeBag)

        input.companyDetailButtonDidClicked.asObservable()
            .map {
                RecruitmentDetailStep.companyDetailIsRequired(
                    id: self.companyId ?? 0
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.bookMarkButtonDidTap.asObservable()
            .flatMap {
                self.bookmarkUseCase.execute(id: self.recruitmentID ?? 0)
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.applyButtonDidTap.asObservable()
            .withLatestFrom(recruitmentDetailEntity)
            .map { recruitmentDetail in
                RecruitmentDetailStep.applyIsRequired(
                    id: recruitmentDetail.recruitmentID,
                    name: recruitmentDetail.companyName,
                    imageURL: recruitmentDetail.companyProfileURL
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output(
            recruitmentDetailEntity: recruitmentDetailEntity,
            areaListEntity: areaListEntity
        )
    }
}
