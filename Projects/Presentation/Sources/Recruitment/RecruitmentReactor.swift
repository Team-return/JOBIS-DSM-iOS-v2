import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchRecruitmentListUseCase: FetchRecruitmentListUseCase
    private let bookmarkUseCase: BookmarkUseCase

    public init(
        fetchRecruitmentListUseCase: FetchRecruitmentListUseCase,
        bookmarkUseCase: BookmarkUseCase
    ) {
        self.initialState = .init()
        self.fetchRecruitmentListUseCase = fetchRecruitmentListUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    public enum Action {
        case fetchRecruitmentList
        case loadMoreRecruitments
        case bookmarkButtonDidTap(Int)
        case recruitmentDidSelect(Int)
        case searchButtonDidTap
        case filterButtonDidTap
        case updateFilterOptions(jobCode: String, techCode: [String]?, years: [String]?, status: String?)
    }

    public enum Mutation {
        case setRecruitmentList([RecruitmentEntity])
        case appendRecruitmentList([RecruitmentEntity])
        case updateBookmark(Int)
        case incrementPageCount
        case resetPageCount
        case navigateToDetail(Int)
        case navigateToSearch
        case navigateToFilter
        case setFilterOptions(jobCode: String, techCode: [String]?, years: [String]?, status: String?)
        case setLoading(Bool)
    }

    public struct State {
        var recruitmentList: [RecruitmentEntity] = []
        var jobCode: String = ""
        var techCode: [String]?
        var years: [String]?
        var status: String?
        var pageCount: Int = 1
        var isLoading: Bool = false
    }
}

extension RecruitmentReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchRecruitmentList:
            return .concat([
                .just(.resetPageCount),
                .just(.setLoading(true)),
                fetchRecruitmentListUseCase.execute(
                    page: 1,
                    jobCode: currentState.jobCode,
                    techCode: currentState.techCode,
                    years: currentState.years,
                    status: currentState.status
                )
                .asObservable()
                .flatMap { list -> Observable<Mutation> in
                    return .concat([
                        .just(.setRecruitmentList(list)),
                        .just(.setLoading(false))
                    ])
                }
            ])

        case .loadMoreRecruitments:
            let nextPage = currentState.pageCount + 1
            return fetchRecruitmentListUseCase.execute(
                page: nextPage,
                jobCode: currentState.jobCode,
                techCode: currentState.techCode,
                years: currentState.years,
                status: currentState.status
            )
            .asObservable()
            .catch { _ in .empty() }
            .filter { !$0.isEmpty }
            .flatMap { list -> Observable<Mutation> in
                return .concat([
                    .just(.appendRecruitmentList(list)),
                    .just(.incrementPageCount)
                ])
            }

        case let .bookmarkButtonDidTap(id):
            return .concat([
                .just(.updateBookmark(id)),
                bookmarkUseCase.execute(id: id)
                    .asObservable()
                    .flatMap { _ in Observable<Mutation>.empty() }
            ])

        case let .recruitmentDidSelect(id):
            return .just(.navigateToDetail(id))

        case .searchButtonDidTap:
            return .just(.navigateToSearch)

        case .filterButtonDidTap:
            return .just(.navigateToFilter)

        case let .updateFilterOptions(jobCode, techCode, years, status):
            return .just(.setFilterOptions(jobCode: jobCode, techCode: techCode, years: years, status: status))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRecruitmentList(list):
            newState.recruitmentList = list

        case let .appendRecruitmentList(list):
            newState.recruitmentList.append(contentsOf: list)

        case let .updateBookmark(id):
            newState.recruitmentList = newState.recruitmentList.map { item in
                var mutableItem = item
                if mutableItem.recruitID == id {
                    mutableItem.bookmarked.toggle()
                }
                return mutableItem
            }

        case .incrementPageCount:
            newState.pageCount += 1

        case .resetPageCount:
            newState.pageCount = 1

        case let .navigateToDetail(id):
            steps.accept(RecruitmentStep.recruitmentDetailIsRequired(recruitmentId: id))

        case .navigateToSearch:
            steps.accept(RecruitmentStep.searchRecruitmentIsRequired)

        case .navigateToFilter:
            steps.accept(RecruitmentStep.recruitmentFilterIsRequired)

        case let .setFilterOptions(jobCode, techCode, years, status):
            newState.jobCode = jobCode
            newState.techCode = techCode
            newState.years = years
            newState.status = status

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}
