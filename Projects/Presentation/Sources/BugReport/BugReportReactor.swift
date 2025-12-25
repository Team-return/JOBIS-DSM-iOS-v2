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

    public init(
        reportBugUseCase: ReportBugUseCase
    ) {
        self.initialState = .init()
        self.reportBugUseCase = reportBugUseCase
    }

    public enum Action {
        case updateTitle(String)
        case updateContent(String)
        case updateImageList([String])
        case updateMajorType(String)
        case majorViewDidTap
        case bugReportButtonDidTap
    }

    public enum Mutation {
        case setTitle(String)
        case setContent(String)
        case setImageList([String])
        case setMajorType(String)
        case setBugReportButtonIsEnabled(Bool)
        case setBugReportCompleted
    }

    public struct State {
        var title: String = ""
        var content: String = ""
        var imageList: [String] = []
        var majorType: String = "전체"
        var isBugReportButtonEnabled: Bool = false
        var isBugReportCompleted: Bool = false
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

        case let .updateImageList(imageList):
            return .just(.setImageList(imageList))

        case let .updateMajorType(majorType):
            return .just(.setMajorType(majorType))

        case .majorViewDidTap:
            steps.accept(BugReportStep.majorBottomSheetIsRequired)
            return .empty()

        case .bugReportButtonDidTap:
            return reportBugUseCase.execute(req: .init(
                title: currentState.title,
                content: currentState.content,
                developmentArea: DevelopmentType(localizedString: currentState.majorType) ?? .all,
                attachmentUrls: currentState.imageList
            ))
            .asObservable()
            .map { _ in Mutation.setBugReportCompleted }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setTitle(title):
            newState.title = title

        case let .setContent(content):
            newState.content = content

        case let .setImageList(imageList):
            newState.imageList = imageList

        case let .setMajorType(majorType):
            newState.majorType = majorType

        case let .setBugReportButtonIsEnabled(isEnabled):
            newState.isBugReportButtonEnabled = isEnabled

        case .setBugReportCompleted:
            newState.isBugReportCompleted = true
        }
        return newState
    }
}
