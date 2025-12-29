import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class SearchCompanyReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchCompanyListUseCase: FetchCompanyListUseCase

    public init(
        fetchCompanyListUseCase: FetchCompanyListUseCase
    ) {
        self.initialState = .init()
        self.fetchCompanyListUseCase = fetchCompanyListUseCase
    }

    public enum Action {
        case searchTextDidSubmit(String)
        case loadMoreCompanies
        case companyDidSelect(Int)
    }

    public enum Mutation {
        case setCompanyList([CompanyEntity])
        case appendCompanyList([CompanyEntity])
        case setSearchText(String?)
        case incrementPageCount
        case resetPageCount
        case setEmptyViewHidden(Bool)
    }

    public struct State {
        var companyList: [CompanyEntity] = []
        var pageCount: Int = 1
        var searchText: String?
        var isEmptyViewHidden: Bool = true
    }
}

extension SearchCompanyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .searchTextDidSubmit(text):
            guard !text.isEmpty else {
                return .just(.setEmptyViewHidden(false))
            }
            return .concat([
                .just(.setEmptyViewHidden(true)),
                .just(.setSearchText(text)),
                .just(.resetPageCount),
                fetchCompanyListUseCase.execute(page: 1, name: text)
                    .asObservable()
                    .flatMap { list -> Observable<Mutation> in
                        return .just(.setCompanyList(list))
                    }
            ])

        case .loadMoreCompanies:
            guard let searchText = currentState.searchText else {
                return .empty()
            }
            let nextPage = currentState.pageCount + 1
            return fetchCompanyListUseCase.execute(page: nextPage, name: searchText)
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
            steps.accept(SearchCompanyStep.companyDetailIsRequired(id: id))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setCompanyList(list):
            newState.companyList = list

        case let .appendCompanyList(list):
            newState.companyList.append(contentsOf: list)

        case let .setSearchText(text):
            newState.searchText = text

        case .incrementPageCount:
            newState.pageCount += 1

        case .resetPageCount:
            newState.pageCount = 1

        case let .setEmptyViewHidden(isHidden):
            newState.isEmptyViewHidden = isHidden
        }
        return newState
    }
}
