import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class CompanyReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let fetchCompanyListUseCase: FetchCompanyListUseCase

    public init(
        fetchCompanyListUseCase: FetchCompanyListUseCase
    ) {
        self.initialState = .init()
        self.fetchCompanyListUseCase = fetchCompanyListUseCase
    }

    public enum Action {
        case fetchCompanyList
        case loadMoreCompanies
        case companyDidSelect(Int)
        case searchButtonDidTap
    }

    public enum Mutation {
        case setCompanyList([CompanyEntity])
        case appendCompanyList([CompanyEntity])
        case incrementPageCount
        case resetPageCount
        case navigateToDetail(Int)
        case navigateToSearch
    }

    public struct State {
        var companyList: [CompanyEntity] = []
        var pageCount: Int = 1
    }
}

extension CompanyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchCompanyList:
            return .concat([
                .just(.resetPageCount),
                fetchCompanyListUseCase.execute(page: 1)
                    .asObservable()
                    .flatMap { list -> Observable<Mutation> in
                        return .just(.setCompanyList(list))
                    }
            ])

        case .loadMoreCompanies:
            let nextPage = currentState.pageCount + 1
            return fetchCompanyListUseCase.execute(page: nextPage)
                .asObservable()
                .catch { _ in .empty() }
                .filter { !$0.isEmpty }
                .flatMap { list -> Observable<Mutation> in
                    return .concat([
                        .just(.appendCompanyList(list)),
                        .just(.incrementPageCount)
                    ])
                }

        case let .companyDidSelect(id):
            return .just(.navigateToDetail(id))

        case .searchButtonDidTap:
            return .just(.navigateToSearch)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setCompanyList(list):
            newState.companyList = list

        case let .appendCompanyList(list):
            newState.companyList.append(contentsOf: list)

        case .incrementPageCount:
            newState.pageCount += 1

        case .resetPageCount:
            newState.pageCount = 1

        case let .navigateToDetail(id):
            steps.accept(CompanyStep.companyDetailIsRequired(id: id))

        case .navigateToSearch:
            steps.accept(CompanyStep.searchCompanyIsRequired)
        }
        return newState
    }
}
