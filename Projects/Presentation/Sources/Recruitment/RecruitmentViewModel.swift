import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var jobCode: String = ""
    public var techCode: [String]?
    public var years: [String]?
    public var recruitmentData = BehaviorRelay<[RecruitmentEntity]>(value: [])
    private let disposeBag = DisposeBag()
    private let fetchRecruitmentListUseCase: FetchRecruitmentListUseCase
    private let bookmarkUseCase: BookmarkUseCase
    private var pageCount: Int = 1

    init(
        fetchRecruitmentListUseCase: FetchRecruitmentListUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.fetchRecruitmentListUseCase = fetchRecruitmentListUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let bookMarkButtonDidTap: PublishRelay<Int>
        var pageChange: Observable<WillDisplayCellEvent>
        let recruitmentTableViewDidTap: Observable<Int>
        let searchButtonDidTap: Signal<Void>
        let filterButtonDidTap: Signal<Void>
    }

    public struct Output {
        var recruitmentData = BehaviorRelay<[RecruitmentEntity]>(value: [])
    }

    public func transform(_ input: Input) -> Output {
        input.viewAppear.asObservable()
            .flatMap {
                self.pageCount = 1
                return self.fetchRecruitmentListUseCase.execute(
                    page: self.pageCount,
                    jobCode: self.jobCode,
                    techCode: self.techCode,
                    years: self.years
                )
            }
            .bind(onNext: {
                self.recruitmentData.accept([])
                self.recruitmentData.accept(self.recruitmentData.value + $0)
                self.pageCount = 1
            })
            .disposed(by: disposeBag)

        input.pageChange.asObservable()
            .flatMap { _ in
                self.pageCount += 1
                return self.fetchRecruitmentListUseCase.execute(
                    page: self.pageCount,
                    jobCode: self.jobCode,
                    techCode: self.techCode,
                    years: self.years
                )
                    .asObservable()
                    .take(while: {
                        !$0.isEmpty
                    })
            }
            .bind { self.recruitmentData.accept(self.recruitmentData.value + $0) }
            .disposed(by: disposeBag)

        input.bookMarkButtonDidTap.asObservable()
            .do(onNext: { id in
                let updatedData = self.recruitmentData.value.map { item in
                    var mutableItem = item
                    if mutableItem.recruitID == id {
                        mutableItem.bookmarked.toggle()
                    }
                    return mutableItem
                }
                self.recruitmentData.accept(updatedData)
            })
            .flatMap { id in
                self.bookmarkUseCase.execute(id: id)
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.recruitmentTableViewDidTap.asObservable()
            .map {
                RecruitmentStep.recruitmentDetailIsRequired(
                    recruitmentId: $0
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.searchButtonDidTap.asObservable()
            .map {
                RecruitmentStep.searchRecruitmentIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.filterButtonDidTap.asObservable()
            .map { _ in RecruitmentStep.recruitmentFilterIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(recruitmentData: recruitmentData)
    }
}
