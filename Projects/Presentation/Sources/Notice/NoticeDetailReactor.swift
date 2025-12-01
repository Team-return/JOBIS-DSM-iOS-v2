import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class NoticeDetailReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let fetchNoticeDetailUseCase: FetchNoticeDetailUseCase
    public var noticeID: Int?

    init(fetchNoticeDetailUseCase: FetchNoticeDetailUseCase) {
        self.initialState = .init()
        self.fetchNoticeDetailUseCase = fetchNoticeDetailUseCase
    }

    public enum Action {
        case fetchNoticeDetail
    }

    public enum Mutation {
        case setNoticeDetail(NoticeDetailEntity)
    }

    public struct State {
        var noticeDetail: NoticeDetailEntity?
    }
}

extension NoticeDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchNoticeDetail:
            return fetchNoticeDetailUseCase.execute(id: noticeID ?? 0)
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
