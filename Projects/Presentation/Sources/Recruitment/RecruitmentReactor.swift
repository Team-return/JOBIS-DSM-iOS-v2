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
    private let loadRecruitmentFilterUseCase: LoadRecruitmentFilterUseCase

    public init(
        fetchRecruitmentListUseCase: FetchRecruitmentListUseCase,
        bookmarkUseCase: BookmarkUseCase,
        loadRecruitmentFilterUseCase: LoadRecruitmentFilterUseCase
    ) {
        self.initialState = .init()
        self.fetchRecruitmentListUseCase = fetchRecruitmentListUseCase
        self.bookmarkUseCase = bookmarkUseCase
        self.loadRecruitmentFilterUseCase = loadRecruitmentFilterUseCase
    }

    public enum Action {
        case fetchRecruitmentList
        case viewWillAppear
        case loadMoreRecruitments
        case bookmarkButtonDidTap(Int)
        case recruitmentDidSelect(Int)
        case searchButtonDidTap
        case filterButtonDidTap
        case updateSortOption(String)
    }

    public enum Mutation {
        case setRecruitmentList([RecruitmentEntity])
        case appendRecruitmentList([RecruitmentEntity])
        case updateBookmark(Int)
        case incrementPageCount
        case resetPageCount
        case setFilterOptions(jobCode: String, techCode: [String]?, years: [String]?, region: String?, status: String?)
        case setLoading(Bool)
        case setSortType(RecruitmentSortType?)
    }

    public struct State {
        var recruitmentList: [RecruitmentEntity] = []
        var jobCode: String = ""
        var techCode: [String]?
        var years: [String]?
        var region: String?
        var status: String?
        var sortType: RecruitmentSortType?
        var pageCount: Int = 1
        var isLoading: Bool = false
    }
}

extension RecruitmentReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchRecruitmentList:
            let filter = loadRecruitmentFilterUseCase.execute()
            return fetchListMutations(filter: filter)

        case .viewWillAppear:
            let filter = loadRecruitmentFilterUseCase.execute()
            let currentFilter = RecruitmentFilterEntity(
                jobCode: currentState.jobCode,
                techCode: currentState.techCode,
                years: currentState.years,
                region: currentState.region,
                status: currentState.status
            )
            guard filter != currentFilter else { return .empty() }
            return fetchListMutations(filter: filter)

        case .loadMoreRecruitments:
            let nextPage = currentState.pageCount + 1
            return fetchRecruitmentListUseCase.execute(
                page: nextPage,
                jobCode: currentState.jobCode,
                techCode: currentState.techCode,
                years: currentState.years,
                region: currentState.region,
                status: currentState.status,
                sortType: currentState.sortType?.rawValue
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
            steps.accept(RecruitmentStep.recruitmentDetailIsRequired(recruitmentId: id))
            return .empty()

        case .searchButtonDidTap:
            steps.accept(RecruitmentStep.searchRecruitmentIsRequired)
            return .empty()

        case .filterButtonDidTap:
            steps.accept(RecruitmentStep.recruitmentFilterIsRequired)
            return .empty()

        case let .updateSortOption(option):
            let sortType = RecruitmentSortType(localizedString: option)
            return .concat([
                .just(.setSortType(sortType)),
                .just(.resetPageCount),
                .just(.setLoading(true)),
                fetchRecruitmentListUseCase.execute(
                    page: 1,
                    jobCode: currentState.jobCode,
                    techCode: currentState.techCode,
                    years: currentState.years,
                    region: currentState.region,
                    status: currentState.status,
                    sortType: sortType?.rawValue
                )
                .asObservable()
                .flatMap { list -> Observable<Mutation> in
                    return .concat([
                        .just(.setRecruitmentList(list)),
                        .just(.setLoading(false))
                    ])
                }
                .catch { _ in .just(.setLoading(false)) }
            ])
        }
    }

    private func fetchListMutations(filter: RecruitmentFilterEntity) -> Observable<Mutation> {
        return .concat([
            .just(.setFilterOptions(
                jobCode: filter.jobCode,
                techCode: filter.techCode,
                years: filter.years,
                region: filter.region,
                status: filter.status
            )),
            .just(.resetPageCount),
            .just(.setLoading(true)),
            fetchRecruitmentListUseCase.execute(
                page: 1,
                jobCode: filter.jobCode,
                techCode: filter.techCode,
                years: filter.years,
                region: filter.region,
                status: filter.status,
                sortType: currentState.sortType?.rawValue
            )
            .asObservable()
            .flatMap { list -> Observable<Mutation> in
                .concat([
                    .just(.setRecruitmentList(list)),
                    .just(.setLoading(false))
                ])
            }
        ])
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

        case let .setFilterOptions(jobCode, techCode, years, region, status):
            newState.jobCode = jobCode
            newState.techCode = techCode
            newState.years = years
            newState.region = region
            newState.status = status

        case let .setLoading(isLoading):
            newState.isLoading = isLoading

        case let .setSortType(sortType):
            newState.sortType = sortType
        }
        return newState
    }
}
