import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class CompanyViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchCompanyListUseCase: FetchCompanyListUseCase
    private var companyList = BehaviorRelay<[CompanyEntity]>(value: [])
    private var pageCount: Int = 1
    private var companyId: Int?

    public init(
        fetchCompanyListUseCase: FetchCompanyListUseCase
    ) {
        self.fetchCompanyListUseCase = fetchCompanyListUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        var pageChange: Observable<WillDisplayCellEvent>
        let companyTableViewCellDidTap: Observable<Int>
        let searchButtonDidTap: PublishRelay<Void>
    }

    public struct Output {
        var companyList = BehaviorRelay<[CompanyEntity]>(value: [])
    }

    public func transform(_ input: Input) -> Output {
        input.viewAppear.asObservable()
            .flatMap {
                self.pageCount = 1
                return self.fetchCompanyListUseCase.execute(page: self.pageCount)
            }
            .bind(onNext: {
                self.companyList.accept([])
                self.companyList.accept(self.companyList.value + $0)
            })
            .disposed(by: disposeBag)

        input.pageChange.asObservable()
            .flatMap { _ in
                self.pageCount += 1
                return self.fetchCompanyListUseCase.execute(page: self.pageCount)
                    .asObservable()
                    .take(while: {
                        !$0.isEmpty
                    })
            }
            .bind { self.companyList.accept(self.companyList.value + $0) }
            .disposed(by: disposeBag)

        input.companyTableViewCellDidTap.asObservable()
            .map { CompanyStep.companyDetailIsRequired(id: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.searchButtonDidTap.asObservable()
            .map { CompanyStep.searchCompanyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(companyList: companyList)
    }
}
