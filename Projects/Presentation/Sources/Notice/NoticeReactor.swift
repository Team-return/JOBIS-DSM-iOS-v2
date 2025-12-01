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

    init(fetchNoticeListUseCase: FetchNoticeListUseCase) {
        self.initialState = .init()
        self.fetchNoticeListUseCase = fetchNoticeListUseCase
    }

    public enum Action {
        case fetchNoticeList
        case noticeDidSelect(Int)
    }

    public enum Mutation {
        case setNoticeList([NoticeEntity])
        case navigateToDetail(Int)
    }

    public struct State {
        var noticeList: [NoticeEntity] = []
    }
}

extension NoticeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNoticeList:
            return fetchNoticeListUseCase.execute()
                .asObservable()
                .map { Mutation.setNoticeList($0) }

        case let .noticeDidSelect(id):
            return .just(.navigateToDetail(id))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setNoticeList(list):
            newState.noticeList = list

        case let .navigateToDetail(id):
            steps.accept(NoticeStep.noticeDetailIsRequired(id: id))
        }
        return newState
    }
}
