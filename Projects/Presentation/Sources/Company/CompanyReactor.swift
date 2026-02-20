import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class CompanyReactor: BaseReactor, Stepper {
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
        case fetchCompanyList
        case loadMoreCompanies
        case companyDidSelect(Int)
        case searchButtonDidTap
        case updateSortOption(String)
    }

    public enum Mutation {
        case setCompanyList([CompanyEntity])
        case appendCompanyList([CompanyEntity])
        case incrementPageCount
        case resetPageCount
        case setSortType(String?)
    }

    public struct State {
        var companyList: [CompanyEntity] = []
        var sortType: String?
        var pageCount: Int = 1
    }
}

extension CompanyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchCompanyList:
            return .concat([
                .just(.resetPageCount),
                fetchCompanyListUseCase.execute(
                    page: 1,
                    sortType: currentState.sortType
                )
                .asObservable()
                .flatMap { list -> Observable<Mutation> in
                    return .just(.setCompanyList(list))
                }
            ])

        case .loadMoreCompanies:
            let nextPage = currentState.pageCount + 1
            return fetchCompanyListUseCase.execute(
                page: nextPage,
                sortType: currentState.sortType
            )
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
            steps.accept(CompanyStep.companyDetailIsRequired(id: id))
            return .empty()

        case .searchButtonDidTap:
            steps.accept(CompanyStep.searchCompanyIsRequired)
            return .empty()

        case let .updateSortOption(option):
            let sortType: String? = {
                switch option {
                case "매출": return "TAKE"
                case "직원 ↓": return "WORKERS_COUNT_DESC"
                case "직원 ↑": return "WORKERS_COUNT_ASC"
                case "설립일 ↓": return "FOUNDED_AT_DESC"
                case "설립일 ↑": return "FOUNDED_AT_ASC"
                default: return nil
                }
            }()
            return .concat([
                .just(.setSortType(sortType)),
                .just(.resetPageCount),
                fetchCompanyListUseCase.execute(
                    page: 1,
                    sortType: sortType
                )
                .asObservable()
                .flatMap { list -> Observable<Mutation> in
                    return .just(.setCompanyList(list))
                }
            ])
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

        case let .setSortType(sortType):
            newState.sortType = sortType
        }
        return newState
    }
}
