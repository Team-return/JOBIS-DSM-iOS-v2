import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var jobCode: String = ""
    public var techCode: String = ""
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
                print("------------------ recruit! ---------------------")
                dump(self.jobCode)
                dump(self.techCode)
                print("------------------ ------- ---------------------")
                return self.fetchRecruitmentListUseCase.execute(
                    page: self.pageCount
//                    jobCode: self.jobCode,
//                    techCode: self.techCode
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
                return self.fetchRecruitmentListUseCase.execute(page: self.pageCount)
                    .asObservable()
                    .take(while: {
                        !$0.isEmpty
                    })
            }
            .bind { self.recruitmentData.accept(self.recruitmentData.value + $0) }
            .disposed(by: disposeBag)

        input.bookMarkButtonDidTap.asObservable()
            .do(onNext: { id in
                var oldData = self.recruitmentData.value
                oldData.enumerated().forEach {
                    if $0.element.recruitID == id {
                        oldData[$0.offset].bookmarked.toggle()
                    }
                }
                self.recruitmentData.accept(oldData)
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
                RecruitmentStep.recruitmentSearchIsRequired
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
