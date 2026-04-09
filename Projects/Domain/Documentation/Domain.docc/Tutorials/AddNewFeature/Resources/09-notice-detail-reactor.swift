import ReactorKit
import RxSwift
import RxFlow
import Core
import Domain

public final class NoticeDetailReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchNoticeDetailUseCase: FetchNoticeDetailUseCase
    public let noticeID: Int

    public init(
        noticeID: Int,
        fetchNoticeDetailUseCase: FetchNoticeDetailUseCase
    ) {
        self.noticeID = noticeID
        self.initialState = .init()
        self.fetchNoticeDetailUseCase = fetchNoticeDetailUseCase
    }

    // MARK: - Action: ViewController → Reactor
    public enum Action {
        case fetchNoticeDetail
    }

    // MARK: - Mutation: 상태 변경 단위
    public enum Mutation {
        case setNoticeDetail(NoticeDetailEntity)
    }

    // MARK: - State: UI에 바인딩되는 상태
    public struct State {
        var noticeDetail: NoticeDetailEntity?
    }
}

extension NoticeDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNoticeDetail:
            return fetchNoticeDetailUseCase.execute(id: noticeID)
                .asObservable()
                .map { Mutation.setNoticeDetail($0) }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setNoticeDetail(detail):
            newState.noticeDetail = detail
        }
        return newState
    }
}
