import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public enum RecruitmentDetailPreviousViewType {
    case companyDeatil
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
        case navigateToCompanyDetail
        case navigateToApply(id: Int, name: String, imageURL: String)
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
            return fetchRecruitmentDetailUseCase.execute(id: currentState.recruitmentID ?? 0)
                .asObservable()
                .map { Mutation.setRecruitmentDetail($0) }

        case .companyDetailButtonDidTap:
            return .just(.navigateToCompanyDetail)

        case .bookmarkButtonDidTap:
            return bookmarkUseCase.execute(id: currentState.recruitmentID ?? 0)
                .asObservable()
                .flatMap { _ in Observable<Mutation>.empty() }

        case .applyButtonDidTap:
            guard let detail = currentState.recruitmentDetail else {
                return .empty()
            }
            return .just(.navigateToApply(
                id: detail.recruitmentID,
                name: detail.companyName,
                imageURL: detail.companyProfileURL
            ))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRecruitmentDetail(detail):
            newState.recruitmentDetail = detail
            newState.companyId = detail.companyID

        case .navigateToCompanyDetail:
            steps.accept(RecruitmentDetailStep.companyDetailIsRequired(
                id: state.companyId ?? 0
            ))

        case let .navigateToApply(id, name, imageURL):
            steps.accept(RecruitmentDetailStep.applyIsRequired(
                id: id,
                name: name,
                imageURL: imageURL
            ))
        }
        return newState
    }
}
