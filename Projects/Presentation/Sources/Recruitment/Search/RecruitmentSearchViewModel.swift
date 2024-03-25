import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentSearchViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchRecruitmentListUseCase: FetchRecruitmentListUseCase
    private let bookmarkUseCase: BookmarkUseCase
    private var recruitmentListInfo = BehaviorRelay<[RecruitmentEntity]>(value: [])
    private var pageCount: Int = 1
    public var searchText: String?

    init(
        fetchRecruitmentListUseCase: FetchRecruitmentListUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.fetchRecruitmentListUseCase = fetchRecruitmentListUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let pageChange: Observable<WillDisplayCellEvent>
        let searchButtonDidTap: PublishRelay<String>
        let bookmarkButtonDidClicked: PublishRelay<Int>
        let searchTableViewDidTap: ControlEvent<IndexPath>
    }

    public struct Output {
        let recruitmentListInfo: BehaviorRelay<[RecruitmentEntity]>
        let emptyViewIsHidden: PublishRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let emptyViewIsHidden = PublishRelay<Bool>()
        input.viewAppear.asObservable()
            .skip(1)
            .flatMap {
                self.pageCount = 1
                return self.fetchRecruitmentListUseCase.execute(page: self.pageCount, name: self.searchText)
            }
            .bind(onNext: {
                self.recruitmentListInfo.accept([])
                self.recruitmentListInfo.accept(self.recruitmentListInfo.value + $0)
                self.pageCount = 1
            })
            .disposed(by: disposeBag)

        input.pageChange.asObservable()
            .distinctUntilChanged({ $0.indexPath.row })
            .flatMap { _ in
                self.pageCount += 1
                return self.fetchRecruitmentListUseCase.execute(page: self.pageCount, name: self.searchText)
            }
            .bind { self.recruitmentListInfo.accept(self.recruitmentListInfo.value + $0) }
            .disposed(by: disposeBag)

        input.searchButtonDidTap.asObservable()
            .filter {
                emptyViewIsHidden.accept($0 != "")
                return $0 != ""
            }
            .flatMap {
                self.pageCount = 1
                return self.fetchRecruitmentListUseCase.execute(page: self.pageCount, name: $0)
            }
            .bind(onNext: {
                self.recruitmentListInfo.accept([])
                self.recruitmentListInfo.accept(self.recruitmentListInfo.value + $0)
            })
            .disposed(by: disposeBag)

        input.bookmarkButtonDidClicked.asObservable()
            .flatMap { id in
                self.bookmarkUseCase.execute(id: id)
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.searchTableViewDidTap.asObservable()
            .map {
                RecruitmentSearchStep.recruitmentDetailIsRequired(
                    id: self.recruitmentListInfo.value[$0.row].recruitID
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            recruitmentListInfo: recruitmentListInfo,
            emptyViewIsHidden: emptyViewIsHidden
        )
    }
}
