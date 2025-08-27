import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class SearchReviewViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var searchText: String?
    private let disposeBag = DisposeBag()
    private let fetchReviewListUseCase: FetchReviewListUseCase
    private var reviewListInfo = BehaviorRelay<[ReviewEntity]>(value: [])
    private var pageCount: Int = 1

    init(
        fetchReviewListUseCase: FetchReviewListUseCase
    ) {
        self.fetchReviewListUseCase = fetchReviewListUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let pageChange: Observable<WillDisplayCellEvent>
        let searchButtonDidTap: PublishRelay<String>
        let searchTableViewDidTap: ControlEvent<IndexPath>
    }

    public struct Output {
        let reviewListInfo: BehaviorRelay<[ReviewEntity]>
        let emptyViewIsHidden: PublishRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let emptyViewIsHidden = PublishRelay<Bool>()
        input.viewAppear.asObservable()
            .skip(1)
            .flatMap {
                self.pageCount = 1
                return self.fetchReviewListUseCase.execute(
                    page: self.pageCount,
                    companyName: self.searchText,
                    writer: self.searchText
                ).asObservable()
            }
            .bind(onNext: {
                self.reviewListInfo.accept([])
                self.reviewListInfo.accept(self.reviewListInfo.value + $0)
                self.pageCount = 1
            })
            .disposed(by: disposeBag)

        input.pageChange.asObservable()
            .distinctUntilChanged({ $0.indexPath.row })
            .flatMap { _ in
                self.pageCount += 1
                return self.fetchReviewListUseCase.execute(
                    page: self.pageCount,
                    companyName: self.searchText,
                    writer: self.searchText
                ).asObservable()
            }
            .bind { self.reviewListInfo.accept(self.reviewListInfo.value + $0) }
            .disposed(by: disposeBag)

        input.searchButtonDidTap.asObservable()
            .flatMap { keyword -> Observable<[ReviewEntity]> in
                emptyViewIsHidden.accept(!keyword.isEmpty)
                self.pageCount = 1
                let query = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

                return self.fetchReviewListUseCase.execute(
                    page: self.pageCount,
                    companyName: nil,
                    writer: nil
                )
                .map { list in
                    list.filter { review in
                        let companyMatch = review.companyName.lowercased().contains(query)
                        let writerMatch = review.writer.lowercased().contains(query)
                        return companyMatch || writerMatch
                    }
                }
                .asObservable()
            }
            .bind(onNext: {
                self.reviewListInfo.accept([])
                self.reviewListInfo.accept(self.reviewListInfo.value + $0)
            })
            .disposed(by: disposeBag)

        return Output(
            reviewListInfo: self.reviewListInfo,
            emptyViewIsHidden: emptyViewIsHidden
        )
    }
}
