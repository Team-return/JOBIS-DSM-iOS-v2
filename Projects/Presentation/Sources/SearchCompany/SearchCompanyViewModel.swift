import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class SearchCompanyViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchCompanyListUseCase: FetchCompanyListUseCase
    private var companyListInfo = BehaviorRelay<[CompanyEntity]>(value: [])
    private var pageCount: Int = 1
    public var searchText: String?

    init(
        fetchCompanyListUseCase: FetchCompanyListUseCase
    ) {
        self.fetchCompanyListUseCase = fetchCompanyListUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let pageChange: Observable<WillDisplayCellEvent>
        let searchButtonDidTap: PublishRelay<String>
        let searchTableViewDidTap: ControlEvent<IndexPath>
    }

    public struct Output {
        let companyListInfo: BehaviorRelay<[CompanyEntity]>
        let emptyViewIsHidden: PublishRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let emptyViewIsHidden = PublishRelay<Bool>()
        input.viewAppear.asObservable()
            .skip(1)
            .flatMap {
                self.pageCount = 1
                return self.fetchCompanyListUseCase.execute(page: self.pageCount, name: self.searchText)
            }
            .bind(onNext: {
                self.companyListInfo.accept([])
                self.companyListInfo.accept(self.companyListInfo.value + $0)
                self.pageCount = 1
            })
            .disposed(by: disposeBag)

        input.pageChange.asObservable()
            .distinctUntilChanged({ $0.indexPath.row })
            .flatMap { _ in
                self.pageCount += 1
                return self.fetchCompanyListUseCase.execute(page: self.pageCount, name: self.searchText)
            }
            .bind { self.companyListInfo.accept(self.companyListInfo.value + $0) }
            .disposed(by: disposeBag)

        input.searchButtonDidTap.asObservable()
            .filter {
                emptyViewIsHidden.accept(!$0.isEmpty)
                return $0 != ""
            }
            .flatMap {
                self.pageCount = 1
                return self.fetchCompanyListUseCase.execute(page: self.pageCount, name: $0)
            }
            .bind(onNext: {
                self.companyListInfo.accept([])
                self.companyListInfo.accept(self.companyListInfo.value + $0)
            })
            .disposed(by: disposeBag)

        input.searchTableViewDidTap.asObservable()
            .map {
                SearchCompanyStep.companyDetailIsRequired(
                    id: self.companyListInfo.value[$0.row].companyID
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            companyListInfo: companyListInfo,
            emptyViewIsHidden: emptyViewIsHidden
        )
    }
}
