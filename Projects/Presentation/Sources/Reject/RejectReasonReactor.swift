import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RejectReasonReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchRejectionReasonUseCase: FetchRejectionReasonUseCase
    public let applicationID: Int
    public let recruitmentID: Int
    public let companyName: String
    public let companyImageUrl: String

    public init(
        fetchRejectionReasonUseCase: FetchRejectionReasonUseCase,
        applicationID: Int,
        recruitmentID: Int,
        companyName: String,
        companyImageUrl: String
    ) {
        self.initialState = .init()
        self.fetchRejectionReasonUseCase = fetchRejectionReasonUseCase
        self.applicationID = applicationID
        self.recruitmentID = recruitmentID
        self.companyName = companyName
        self.companyImageUrl = companyImageUrl
    }

    public enum Action {
        case fetchRejectReason
        case reApplyButtonDidTap
    }

    public enum Mutation {
        case setRejectReason(String)
    }

    public struct State {
        var rejectReason: String = "반려 사유 불러오는중..."
    }
}

extension RejectReasonReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchRejectReason:
            return fetchRejectionReasonUseCase.execute(id: applicationID)
                .asObservable()
                .map { Mutation.setRejectReason($0) }

        case .reApplyButtonDidTap:
            steps.accept(RejectReasonStep.reApplyIsRequired(
                recruitmentID: recruitmentID,
                applicationID: applicationID,
                companyName: companyName,
                companyImageUrl: companyImageUrl
            ))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRejectReason(reason):
            newState.rejectReason = reason
        }
        return newState
    }
}
