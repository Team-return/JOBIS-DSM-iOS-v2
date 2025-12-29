import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public enum RecruitmentDetailPreviousViewType {
    case companyDetail
    case recruitmentList
}

public final class RecruitmentDetailReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let fetchRecruitmentDetailUseCase: FetchRecruitmentDetailUseCase
    private let bookmarkUseCase: BookmarkUseCase

    public init(
        fetchRecruitmentDetailUseCase: FetchRecruitmentDetailUseCase,
        bookmarkUseCase: BookmarkUseCase,
        recruitmentID: Int? = nil,
        companyId: Int? = nil,
        type: RecruitmentDetailPreviousViewType = .recruitmentList
    ) {
        self.initialState = .init(
            recruitmentID: recruitmentID,
            companyId: companyId,
            type: type
        )
        self.fetchRecruitmentDetailUseCase = fetchRecruitmentDetailUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    public enum Action {
        case fetchRecruitmentDetail
        case companyDetailButtonDidTap
        case bookmarkButtonDidTap
        case applyButtonDidTap
    }

    public enum Mutation {
        case setRecruitmentDetail(RecruitmentDetailEntity)
    }

    public struct State {
        var recruitmentDetail: RecruitmentDetailEntity?
        var recruitmentID: Int?
        var companyId: Int?
        var type: RecruitmentDetailPreviousViewType = .recruitmentList
    }
}

extension RecruitmentDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchRecruitmentDetail:
            guard let recruitmentID = currentState.recruitmentID else {
                return .empty()
            }
            return fetchRecruitmentDetailUseCase.execute(id: recruitmentID)
                .asObservable()
                .map { Mutation.setRecruitmentDetail($0) }

        case .companyDetailButtonDidTap:
            guard let companyId = currentState.companyId else {
                return .empty()
            }
            steps.accept(RecruitmentDetailStep.companyDetailIsRequired(id: companyId))
            return .empty()

        case .bookmarkButtonDidTap:
            guard let recruitmentID = currentState.recruitmentID else {
                return .empty()
            }
            return bookmarkUseCase.execute(id: recruitmentID)
                .asObservable()
                .catch { _ in .empty() }
                .flatMap { _ in Observable<Mutation>.empty() }

        case .applyButtonDidTap:
            guard let detail = currentState.recruitmentDetail else {
                return .empty()
            }
            steps.accept(RecruitmentDetailStep.applyIsRequired(
                id: detail.recruitmentID,
                name: detail.companyName,
                imageURL: detail.companyProfileURL
            ))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRecruitmentDetail(detail):
            newState.recruitmentDetail = detail
            newState.companyId = detail.companyID
        }
        return newState
    }
}
