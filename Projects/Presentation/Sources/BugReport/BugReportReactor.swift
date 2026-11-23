import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class BugReportReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let reportBugUseCase: ReportBugUseCase
    private let fetchPresignedURLUseCase: FetchPresignedURLUseCase
    private let uploadImageToS3UseCase: UploadImageToS3UseCase
    public static let maxImageCount = 5

    public init(
        reportBugUseCase: ReportBugUseCase,
        fetchPresignedURLUseCase: FetchPresignedURLUseCase,
        uploadImageToS3UseCase: UploadImageToS3UseCase
    ) {
        self.initialState = .init()
        self.reportBugUseCase = reportBugUseCase
        self.fetchPresignedURLUseCase = fetchPresignedURLUseCase
        self.uploadImageToS3UseCase = uploadImageToS3UseCase
    }

    public enum Action {
        case updateTitle(String)
        case updateContent(String)
        case setImages([UploadFileModel])
        case removeImage(Int)
        case updateMajorType(String)
        case majorViewDidTap
        case bugReportButtonDidTap
    }

    public enum Mutation {
        case setTitle(String)
        case setContent(String)
        case setImages([UploadFileModel])
        case removeImage(Int)
        case setMajorType(String)
        case setBugReportButtonIsEnabled(Bool)
        case setBugReportCompleted
        case setBugReportFailed
        case setLoading(Bool)
    }

    public struct State {
        var title: String = ""
        var content: String = ""
        var imageList: [UploadFileModel] = []
        var majorType: String = "전체"
        var isBugReportButtonEnabled: Bool = false
        var isBugReportCompleted: Bool = false
        var isLoading: Bool = false
        @Pulse var bugReportFailed: Void?
    }
}

extension BugReportReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateTitle(title):
            let isEnabled = !title.isEmpty && !currentState.content.isEmpty
            return .concat([
                .just(.setTitle(title)),
                .just(.setBugReportButtonIsEnabled(isEnabled))
            ])

        case let .updateContent(content):
            let isEnabled = !currentState.title.isEmpty && !content.isEmpty
            return .concat([
                .just(.setContent(content)),
                .just(.setBugReportButtonIsEnabled(isEnabled))
            ])

        case let .setImages(images):
            return .just(.setImages(Array(images.prefix(Self.maxImageCount))))

        case let .removeImage(index):
            return .just(.removeImage(index))

        case let .updateMajorType(majorType):
            return .just(.setMajorType(majorType))

        case .majorViewDidTap:
            steps.accept(BugReportStep.majorBottomSheetIsRequired)
            return .empty()

        case .bugReportButtonDidTap:
            return submitBugReport()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setTitle(title):
            newState.title = title

        case let .setContent(content):
            newState.content = content

        case let .setImages(images):
            newState.imageList = images

        case let .removeImage(index):
            if index < newState.imageList.count {
                newState.imageList.remove(at: index)
            }

        case let .setMajorType(majorType):
            newState.majorType = majorType

        case let .setBugReportButtonIsEnabled(isEnabled):
            newState.isBugReportButtonEnabled = isEnabled

        case .setBugReportCompleted:
            newState.isBugReportCompleted = true

        case .setBugReportFailed:
            newState.bugReportFailed = ()

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
}

private extension BugReportReactor {
    func submitBugReport() -> Observable<Mutation> {
        guard !currentState.isLoading else { return .empty() }
        let title = currentState.title
        let content = currentState.content
        let developmentArea = DevelopmentType(localizedString: currentState.majorType) ?? .all

        return .concat(
            .just(.setLoading(true)),
            uploadImages(currentState.imageList)
                .flatMapCompletable { [reportBugUseCase] filePaths in
                    reportBugUseCase.execute(req: .init(
                        title: title,
                        content: content,
                        developmentArea: developmentArea,
                        attachmentUrls: filePaths
                    ))
                }
                .andThen(Observable<Mutation>.just(.setBugReportCompleted))
                .catch { _ in .concat(
                    .just(.setBugReportFailed),
                    .just(.setLoading(false))
                ) }
        )
    }

    func uploadImages(_ images: [UploadFileModel]) -> Single<[String]> {
        guard !images.isEmpty else { return .just([]) }

        return fetchPresignedURLUseCase.execute(req: .init(files: images.toRequestDTO()))
            .flatMap { [uploadImageToS3UseCase] presignedURLs -> Single<[String]> in
                guard presignedURLs.count == images.count else {
                    return .error(BugReportUploadError.presignedURLMismatch)
                }
                let uploads = zip(images, presignedURLs).map { image, presigned in
                    uploadImageToS3UseCase.execute(
                        presignedURL: presigned.presignedUrl,
                        data: image.file,
                        contentType: image.contentType
                    )
                }
                return Completable.zip(uploads)
                    .andThen(.just(presignedURLs.map { $0.filePath }))
            }
    }
}

private enum BugReportUploadError: Error {
    case presignedURLMismatch
}
