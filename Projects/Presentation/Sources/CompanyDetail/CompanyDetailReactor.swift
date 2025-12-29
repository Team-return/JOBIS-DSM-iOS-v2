import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public enum CompanyDetailPreviousViewType {
    case searchCompany
    case recruitmentDetail
}

public final class CompanyDetailReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let fetchCompanyInfoDetailUseCase: FetchCompanyInfoDetailUseCase
    private let fetchReviewListUseCase: FetchReviewListUseCase
    public var companyID: Int?
    public var recruitmentID: Int?
    public var type: CompanyDetailPreviousViewType = .recruitmentDetail

    public init(
        fetchCompanyInfoDetailUseCase: FetchCompanyInfoDetailUseCase,
        fetchReviewListUseCase: FetchReviewListUseCase
    ) {
        self.initialState = .init()
        self.fetchCompanyInfoDetailUseCase = fetchCompanyInfoDetailUseCase
        self.fetchReviewListUseCase = fetchReviewListUseCase
    }

    public enum Action {
        case fetchCompanyDetail
        case recruitmentButtonDidTap
        case interviewReviewDidSelect(Int, String)
    }

    public enum Mutation {
        case setCompanyDetail(CompanyInfoDetailEntity)
        case setReviewList([ReviewEntity])
    }

    public struct State {
        var companyDetail: CompanyInfoDetailEntity?
        var reviewList: [ReviewEntity] = []
    }
}

extension CompanyDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchCompanyDetail:
            let companyDetail = fetchCompanyInfoDetailUseCase.execute(id: companyID ?? 0)
                .asObservable()
                .map { Mutation.setCompanyDetail($0) }

            let reviewList = fetchReviewListUseCase.execute(companyID: companyID)
                .asObservable()
                .map { Mutation.setReviewList($0) }

            return .merge(companyDetail, reviewList)

        case .recruitmentButtonDidTap:
            if type != .recruitmentDetail, let recruitmentID = recruitmentID {
                steps.accept(CompanyDetailStep.recruitmentDetailIsRequired(id: recruitmentID))
            } else {
                steps.accept(CompanyDetailStep.popIsRequired)
            }
            return .empty()

        case let .interviewReviewDidSelect(id, name):
            steps.accept(CompanyDetailStep.interviewReviewDetailIsRequired(id: id, name: name))
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setCompanyDetail(detail):
            newState.companyDetail = detail
            self.recruitmentID = detail.recruitmentID

        case let .setReviewList(list):
            newState.reviewList = list
        }

        return newState
    }
}
