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
    private let fetchPresignedURLUseCase: FetchPresignedURLUseCase
    private let uploadImageToS3UseCase: UploadImageToS3UseCase
    private let recruitmentId: Int?
    private let applicationId: Int?
    private let applyType: ApplyType
    public let companyName: String
    public let companyImageURL: String

    public init(
        applyCompanyUseCase: ApplyCompanyUseCase,
        reApplyCompanyUseCase: ReApplyCompanyUseCase,
        fetchPresignedURLUseCase: FetchPresignedURLUseCase,
        uploadImageToS3UseCase: UploadImageToS3UseCase,
        recruitmentId: Int? = nil,
        applicationId: Int? = nil,
        companyName: String,
        companyImageURL: String,
        applyType: ApplyType
    ) {
        self.applyCompanyUseCase = applyCompanyUseCase
        self.reApplyCompanyUseCase = reApplyCompanyUseCase
        self.fetchPresignedURLUseCase = fetchPresignedURLUseCase
        self.uploadImageToS3UseCase = uploadImageToS3UseCase
        self.recruitmentId = recruitmentId
        self.applicationId = applicationId
        self.companyName = companyName
        self.companyImageURL = companyImageURL
        self.applyType = applyType
        self.initialState = .init()
    }

    public enum Action {
        case documentDidAdd(UploadFileModel)
        case urlAddButtonDidTap
        case urlDidChange(Int, String)
        case applyButtonDidTap
        case removeUrl(Int)
        case removeDocument(Int)
    }

    public enum Mutation {
        case addDocument(UploadFileModel)
        case addUrl
        case updateUrl(Int, String)
        case removeUrl(Int)
        case removeDocument(Int)
        case updateApplyButtonEnabled(Bool)
        case setLoading(Bool)
    }

    public struct State {
        var documents: [UploadFileModel] = []
        var urls: [AttachmentsRequestQuery] = []
        var applyButtonEnabled: Bool = false
        var isLoading: Bool = false
    }
}

extension ApplyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .documentDidAdd(document):
            let newDocuments = currentState.documents + [document]
            let isEnabled = isApplyEnabled(documents: newDocuments, urls: currentState.urls)
            return .concat(
                .just(.addDocument(document)),
                .just(.updateApplyButtonEnabled(isEnabled))
            )

        case .urlAddButtonDidTap:
            let newUrls = currentState.urls + [.init(url: "", type: .url)]
            let isEnabled = isApplyEnabled(documents: currentState.documents, urls: newUrls)
            return .concat(
                .just(.addUrl),
                .just(.updateApplyButtonEnabled(isEnabled))
            )

        case let .urlDidChange(index, url):
            var newUrls = currentState.urls
            if index < newUrls.count {
                newUrls[index] = .init(url: url, type: .url)
            }
            let isEnabled = isApplyEnabled(documents: currentState.documents, urls: newUrls)
            return .concat(
                .just(.updateUrl(index, url)),
                .just(.updateApplyButtonEnabled(isEnabled))
            )

        case .applyButtonDidTap:
            return submitApplication()

        case let .removeUrl(index):
            var newUrls = currentState.urls
            if index < newUrls.count {
                newUrls.remove(at: index)
            }
            let isEnabled = isApplyEnabled(documents: currentState.documents, urls: newUrls)
            return .concat(
                .just(.removeUrl(index)),
                .just(.updateApplyButtonEnabled(isEnabled))
            )

        case let .removeDocument(index):
            var newDocuments = currentState.documents
            if index < newDocuments.count {
                newDocuments.remove(at: index)
            }
            let isEnabled = isApplyEnabled(documents: newDocuments, urls: currentState.urls)
            return .concat(
                .just(.removeDocument(index)),
                .just(.updateApplyButtonEnabled(isEnabled))
            )
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .addDocument(document):
            newState.documents.append(document)

        case .addUrl:
            newState.urls.append(.init(url: "", type: .url))

        case let .updateUrl(index, url):
            if index < newState.urls.count {
                newState.urls[index] = .init(url: url, type: .url)
            }

        case let .removeUrl(index):
            if index < newState.urls.count {
                newState.urls.remove(at: index)
            }

        case let .removeDocument(index):
            if index < newState.documents.count {
                newState.documents.remove(at: index)
            }

        case let .updateApplyButtonEnabled(enabled):
            newState.applyButtonEnabled = enabled

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }
}

private extension ApplyReactor {
    func isApplyEnabled(documents: [UploadFileModel], urls: [AttachmentsRequestQuery]) -> Bool {
        !documents.isEmpty || !nonEmptyUrls(urls).isEmpty
    }

    func nonEmptyUrls(_ urls: [AttachmentsRequestQuery]) -> [AttachmentsRequestQuery] {
        urls.filter { !$0.url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    func submitApplication() -> Observable<Mutation> {
        guard !currentState.isLoading else { return .empty() }
        return .concat(
            .just(.setLoading(true)),
            uploadDocuments(currentState.documents)
                .asObservable()
                .flatMap { [weak self] fileAttachments -> Observable<Mutation> in
                    guard let self else { return .empty() }
                    let urls = self.nonEmptyUrls(self.currentState.urls)
                    return self.apply(attachments: fileAttachments + urls)
                }
                .catch { [weak self] _ in
                    self?.steps.accept(ApplyStep.errorToast(message: "파일 업로드에 실패했습니다"))
                    return .just(.setLoading(false))
                }
        )
    }

    func uploadDocuments(_ documents: [UploadFileModel]) -> Single<[AttachmentsRequestQuery]> {
        guard !documents.isEmpty else { return .just([]) }

        return fetchPresignedURLUseCase.execute(req: .init(files: documents.toRequestDTO()))
            .flatMap { [uploadImageToS3UseCase] presignedURLs -> Single<[AttachmentsRequestQuery]> in
                guard presignedURLs.count == documents.count else {
                    return .error(ApplyUploadError.presignedURLMismatch)
                }
                let uploads = zip(documents, presignedURLs).map { document, presigned in
                    uploadImageToS3UseCase.execute(
                        presignedURL: presigned.presignedUrl,
                        data: document.file,
                        contentType: document.contentType
                    )
                }
                return Completable.zip(uploads)
                    .andThen(.just(presignedURLs.map { .init(url: $0.filePath, type: .file) }))
            }
    }

    func apply(attachments: [AttachmentsRequestQuery]) -> Observable<Mutation> {
        let applyRequest: Completable
        if applyType == .apply {
            guard let recruitmentId else { return .empty() }
            applyRequest = applyCompanyUseCase.execute(
                id: recruitmentId,
                req: .init(attachments: attachments)
            )
        } else {
            guard let applicationId else { return .empty() }
            applyRequest = reApplyCompanyUseCase.execute(
                id: applicationId,
                req: .init(attachments: attachments)
            )
        }

        return applyRequest
            .andThen(Observable<Mutation>.empty())
            .do(onCompleted: { [weak self] in
                self?.steps.accept(ApplyStep.homeIsRequired)
            })
            .catch { [weak self] error in
                let message = (error as? ApplicationsError) == .conflict
                    ? "진행 중이거나 합격한 지원이 있어 지원할 수 없습니다"
                    : "지원에 실패했습니다"
                self?.steps.accept(ApplyStep.errorToast(message: message))
                return .just(.setLoading(false))
            }
    }
}

private enum ApplyUploadError: Error {
    case presignedURLMismatch
}
