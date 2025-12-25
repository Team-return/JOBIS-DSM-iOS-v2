import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain
import ReactorKit

public final class MyPageReactor: BaseReactor, Stepper {
    public enum Action {
        case viewWillAppear
        case reviewNavigateButtonDidTap(Int)
        case profileImageSelected(UploadFileModel)
        case notificationSettingDidTap
        case helpDidTap
        case bugReportDidTap
        case interestFieldDidTap
        case changePasswordDidTap
        case logout
        case withdrawal
    }

    public enum Mutation {
        case setStudentInfo(StudentInfoEntity)
        case setWritableReviewList([WritableReviewCompanyEntity])
        case updateProfileImage
        case navigateToReview(Int)
        case navigateToNotificationSetting
        case navigateToHelp
        case navigateToBugReport
        case navigateToInterestField
        case navigateToChangePassword
        case navigateToTabs
    }

    public struct State {
        var studentInfo: StudentInfoEntity?
        var writableReviewList: [WritableReviewCompanyEntity] = []
    }

    public var initialState: State
    public let steps = PublishRelay<Step>()

    private let fetchPresignedURLUseCase: FetchPresignedURLUseCase
    private let uploadImageToS3UseCase: UploadImageToS3UseCase
    private let changeProfileImageUseCase: ChangeProfileImageUseCase
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let fetchWritableReviewListUseCase: FetchWritableReviewListUseCase
    private let logoutUseCase: LogoutUseCase
    private let deleteDeviceTokenUseCase: DeleteDeviceTokenUseCase

    public init(
        fetchPresignedURLUseCase: FetchPresignedURLUseCase,
        uploadImageToS3UseCase: UploadImageToS3UseCase,
        changeProfileImageUseCase: ChangeProfileImageUseCase,
        fetchStudentInfoUseCase: FetchStudentInfoUseCase,
        fetchWritableReviewListUseCase: FetchWritableReviewListUseCase,
        logoutUseCase: LogoutUseCase,
        deleteDeviceTokenUseCase: DeleteDeviceTokenUseCase
    ) {
        self.initialState = State()
        self.fetchPresignedURLUseCase = fetchPresignedURLUseCase
        self.uploadImageToS3UseCase = uploadImageToS3UseCase
        self.changeProfileImageUseCase = changeProfileImageUseCase
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        self.fetchWritableReviewListUseCase = fetchWritableReviewListUseCase
        self.logoutUseCase = logoutUseCase
        self.deleteDeviceTokenUseCase = deleteDeviceTokenUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let studentInfo = fetchStudentInfoUseCase.execute()
                .asObservable()
                .map { Mutation.setStudentInfo($0) }

            let writableReviewList = fetchWritableReviewListUseCase.execute()
                .asObservable()
                .map { Mutation.setWritableReviewList($0) }

            return Observable.merge(studentInfo, writableReviewList)

        case let .reviewNavigateButtonDidTap(id):
            return .just(.navigateToReview(id))

        case let .profileImageSelected(file):
            return fetchPresignedURLUseCase.execute(
                req: .init(files: [.init(fileName: file.fileName)])
            )
            .asObservable()
            .flatMap { [weak self] presignedURLs -> Observable<Mutation> in
                guard let self = self,
                      let url = presignedURLs.first else { return .empty() }

                return Observable.zip(
                    self.uploadImageToS3UseCase.execute(
                        presignedURL: url.presignedUrl,
                        data: file.file
                    )
                    .asObservable(),
                    self.changeProfileImageUseCase.execute(url: url.filePath)
                        .asObservable()
                )
                .flatMap { _ in
                    Observable.concat([
                        .just(.updateProfileImage),
                        self.fetchStudentInfoUseCase.execute()
                            .asObservable()
                            .map { Mutation.setStudentInfo($0) }
                    ])
                }
            }

        case .notificationSettingDidTap:
            return .just(.navigateToNotificationSetting)

        case .helpDidTap:
            return .just(.navigateToHelp)

        case .bugReportDidTap:
            return .just(.navigateToBugReport)

        case .interestFieldDidTap:
            return .just(.navigateToInterestField)

        case .changePasswordDidTap:
            return .just(.navigateToChangePassword)

        case .logout:
            logoutUseCase.execute()
            deleteDeviceTokenUseCase.execute()
            return .just(.navigateToTabs)

        case .withdrawal:
            logoutUseCase.execute()
            deleteDeviceTokenUseCase.execute()
            return .just(.navigateToTabs)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setStudentInfo(studentInfo):
            newState.studentInfo = studentInfo

        case let .setWritableReviewList(list):
            newState.writableReviewList = list

        case .updateProfileImage:
            break

        case let .navigateToReview(id):
            steps.accept(MyPageStep.writableReviewIsRequired(id))

        case .navigateToNotificationSetting:
            steps.accept(MyPageStep.notificationSettingIsRequired)

        case .navigateToHelp:
            steps.accept(MyPageStep.noticeIsRequired)

        case .navigateToBugReport:
            steps.accept(MyPageStep.bugReportIsRequired)

        case .navigateToInterestField:
            steps.accept(MyPageStep.interestFieldIsRequired)

        case .navigateToChangePassword:
            steps.accept(MyPageStep.confirmIsRequired)

        case .navigateToTabs:
            steps.accept(MyPageStep.tabsIsRequired)
        }

        return newState
    }
}
