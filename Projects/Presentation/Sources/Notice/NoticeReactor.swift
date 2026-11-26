import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class NoticeReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let fetchNoticeListUseCase: FetchNoticeListUseCase

    public init(fetchNoticeListUseCase: FetchNoticeListUseCase) {
        self.initialState = .init()
        self.fetchNoticeListUseCase = fetchNoticeListUseCase
    }

    public enum Action {
        case fetchNoticeList
        case loadMoreNotices
        case noticeDidSelect(Int)
    }

    public enum Mutation {
        case setNoticeList([NoticeEntity])
        case appendNoticeList([NoticeEntity])
        case incrementPageCount
        case setLoading(Bool)
    }

    public struct State {
        var noticeList: [NoticeEntity] = []
        var pageCount: Int = 1
        var isLoading: Bool = false
    }
}

extension NoticeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNoticeList:
            return .concat(
                .just(.setLoading(true)),
                fetchNoticeListUseCase.execute(page: 1)
                    .asObservable()
                    .map { Mutation.setNoticeList($0) },
                .just(.setLoading(false))
            )

        case .loadMoreNotices:
            guard !currentState.isLoading else { return .empty() }
            return .concat(
                .just(.setLoading(true)),
                fetchNoticeListUseCase.execute(page: currentState.pageCount + 1)
                    .asObservable()
                    .catch { _ in .empty() }
                    .filter { !$0.isEmpty }
                    .flatMap { list -> Observable<Mutation> in
                        .concat(
                            .just(.appendNoticeList(list)),
                            .just(.incrementPageCount)
                        )
                    },
                .just(.setLoading(false))
            )

        case let .noticeDidSelect(id):
            steps.accept(NoticeStep.noticeDetailIsRequired(id: id))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setNoticeList(list):
            newState.noticeList = list

        case let .appendNoticeList(list):
            let existingIds = Set(newState.noticeList.map { $0.companyId })
            newState.noticeList += list.filter { !existingIds.contains($0.companyId) }

        case .incrementPageCount:
            newState.pageCount += 1

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}
