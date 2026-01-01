import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class WinterInternReactor: BaseReactor, Stepper {
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
        case updateFilterOptions(jobCode: String, techCode: [String]?)
    }

    public enum Mutation {
        case setRecruitmentList([RecruitmentEntity])
        case appendRecruitmentList([RecruitmentEntity])
        case updateBookmark(Int)
        case incrementPageCount
        case resetPageCount
        case setFilterOptions(jobCode: String, techCode: [String]?)
    }

    public struct State {
        var recruitmentList: [RecruitmentEntity] = []
        var jobCode: String = ""
        var techCode: [String]?
        var pageCount: Int = 1
    }
}

extension WinterInternReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchRecruitmentList:
            return .concat([
                .just(.resetPageCount),
                fetchRecruitmentListUseCase.execute(
                    page: 1,
                    jobCode: currentState.jobCode,
                    techCode: currentState.techCode,
                    winterIntern: true
                )
                .asObservable()
                .flatMap { list -> Observable<Mutation> in
                    return .just(.setRecruitmentList(list))
                }
            ])

        case .loadMoreRecruitments:
            let nextPage = currentState.pageCount + 1
            return fetchRecruitmentListUseCase.execute(
                page: nextPage,
                jobCode: currentState.jobCode,
                techCode: currentState.techCode,
                winterIntern: true
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

        case let .updateFilterOptions(jobCode, techCode):
            return .just(.setFilterOptions(jobCode: jobCode, techCode: techCode))
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

        case let .setFilterOptions(jobCode, techCode):
            newState.jobCode = jobCode
            newState.techCode = techCode
        }
        return newState
    }
}
