import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public enum ApplyType {
    case apply
    case reApply
}

public final class ApplyReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()
    private let applyCompanyUseCase: ApplyCompanyUseCase
    private let reApplyCompanyUseCase: ReApplyCompanyUseCase
    public var recruitmentId: Int?
    public var applicationId: Int?
    public var companyName: String?
    public var companyImageURL: String?
    public var applyType: ApplyType = .apply

    public init(
        applyCompanyUseCase: ApplyCompanyUseCase,
        reApplyCompanyUseCase: ReApplyCompanyUseCase
    ) {
        self.initialState = .init()
        self.applyCompanyUseCase = applyCompanyUseCase
        self.reApplyCompanyUseCase = reApplyCompanyUseCase
    }

    public enum Action {
        case documentDidAdd(AttachmentsRequestQuery)
        case urlAddButtonDidTap
        case urlDidChange(Int, String)
        case applyButtonDidTap
        case removeUrl(Int)
        case removeDocument(Int)
    }

    public enum Mutation {
        case addDocument(AttachmentsRequestQuery)
        case addUrl
        case updateUrl(Int, String)
        case removeUrl(Int)
        case removeDocument(Int)
        case updateApplyButtonEnabled(Bool)
    }

    public struct State {
        var documents: [AttachmentsRequestQuery] = []
        var urls: [AttachmentsRequestQuery] = []
        var applyButtonEnabled: Bool = false
    }
}

extension ApplyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .documentDidAdd(document):
            return .just(.addDocument(document))

        case .urlAddButtonDidTap:
            return .just(.addUrl)

        case let .urlDidChange(index, url):
            return .just(.updateUrl(index, url))

        case .applyButtonDidTap:
            let attachments = currentState.documents + currentState.urls

            let applyRequest: Completable
            if applyType == .apply {
                guard let recruitmentId = recruitmentId else {
                    return .empty()
                }
                applyRequest = applyCompanyUseCase.execute(
                    id: recruitmentId,
                    req: .init(attachments: attachments)
                )
            } else {
                guard let applicationId = applicationId else {
                    return .empty()
                }
                applyRequest = reApplyCompanyUseCase.execute(
                    id: applicationId,
                    req: .init(attachments: attachments)
                )
            }

            return applyRequest
                .andThen(Observable<Mutation>.empty())
                .do(onCompleted: { [weak self] in
                    self?.steps.accept(ApplyStep.popToRecruitmentDetail)
                })
                .catch { [weak self] _ in
                    self?.steps.accept(ApplyStep.errorToast(message: "합격된 회사가 존재합니다"))
                    return .empty()
                }

        case let .removeUrl(index):
            return .just(.removeUrl(index))

        case let .removeDocument(index):
            return .just(.removeDocument(index))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .addDocument(document):
            newState.documents.append(document)
            newState.applyButtonEnabled = !newState.documents.isEmpty || !newState.urls.isEmpty

        case .addUrl:
            newState.urls.append(.init(url: "", type: .url))

        case let .updateUrl(index, url):
            if index < newState.urls.count {
                newState.urls[index] = .init(url: url, type: .url)
            }
            newState.applyButtonEnabled = !newState.documents.isEmpty || !newState.urls.isEmpty

        case let .removeUrl(index):
            if index < newState.urls.count {
                newState.urls.remove(at: index)
            }
            newState.applyButtonEnabled = !newState.documents.isEmpty || !newState.urls.isEmpty

        case let .removeDocument(index):
            if index < newState.documents.count {
                newState.documents.remove(at: index)
            }
            newState.applyButtonEnabled = !newState.documents.isEmpty || !newState.urls.isEmpty

        case let .updateApplyButtonEnabled(enabled):
            newState.applyButtonEnabled = enabled
        }

        return newState
    }
}
