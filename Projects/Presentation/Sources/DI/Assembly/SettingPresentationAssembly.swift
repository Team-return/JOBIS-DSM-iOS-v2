import Foundation
import Swinject
import Core
import Domain

public final class SettingPresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(MyPageViewController.self) { resolver in
            MyPageViewController(resolver.resolve(MyPageViewModel.self)!)
        }
        container.register(MyPageViewModel.self) { resolver in
            MyPageViewModel(
                fetchPresignedURLUseCase: resolver.resolve(FetchPresignedURLUseCase.self)!,
                uploadImageToS3UseCase: resolver.resolve(UploadImageToS3UseCase.self)!,
                changeProfileImageUseCase: resolver.resolve(ChangeProfileImageUseCase.self)!,
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!,
                fetchWritableReviewListUseCase: resolver.resolve(FetchWritableReviewListUseCase.self)!,
                logoutUseCase: resolver.resolve(LogoutUseCase.self)!,
                deleteDeviceTokenUseCase: resolver.resolve(DeleteDeviceTokenUseCase.self)!
            )
        }

        // Bookmark
        container.register(BookmarkViewController.self) { resolver in
            BookmarkViewController(resolver.resolve(BookmarkViewModel.self)!)
        }
        container.register(BookmarkViewModel.self) { resolver in
            BookmarkViewModel(
                fetchBookmarkListUseCase: resolver.resolve(FetchBookmarkListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }

        // Alarm
        container.register(AlarmViewController.self) { resolver in
            AlarmViewController(resolver.resolve(AlarmViewModel.self)!)
        }
        container.register(AlarmViewModel.self) { resolver in
            AlarmViewModel(
                fetchNotificationListUseCase: resolver.resolve(FetchNotificationListUseCase.self)!,
                readNotificationUseCase: resolver.resolve(ReadNotificationUseCase.self)!
            )
        }

        // Notification Setting
        container.register(NotificationSettingViewModel.self) { resolver in
            NotificationSettingViewModel(
                subscribeNotificationUseCase: resolver.resolve(SubscribeNotificationUseCase.self)!,
                subscribeAllNotificationUseCase: resolver.resolve(SubscribeAllNotificationUseCase.self)!,
                fetchSubscribeStateUseCase: resolver.resolve(FetchSubscribeStateUseCase.self)!
            )
        }
        container.register(NotificationSettingViewController.self) { resolver in
            NotificationSettingViewController(resolver.resolve(NotificationSettingViewModel.self)!)
        }

        // Notice
        container.register(NoticeReactor.self) { resolver in
            NoticeReactor(
                fetchNoticeListUseCase: resolver.resolve(FetchNoticeListUseCase.self)!
            )
        }
        container.register(NoticeViewController.self) { resolver in
            NoticeViewController(resolver.resolve(NoticeReactor.self)!)
        }

        // Notice Detail
        container.register(NoticeDetailReactor.self) { resolver, noticeID in
            NoticeDetailReactor(
                noticeID: noticeID,
                fetchNoticeDetailUseCase: resolver.resolve(FetchNoticeDetailUseCase.self)!
            )
        }
        container.register(NoticeDetailViewController.self) { resolver, noticeID in
            NoticeDetailViewController(resolver.resolve(NoticeDetailReactor.self, argument: noticeID)!)
        }

        // Bug Report
        container.register(BugReportViewController.self) { resolver in
            BugReportViewController(resolver.resolve(BugReportViewModel.self)!)
        }
        container.register(BugReportViewModel.self) { resolver in
            BugReportViewModel(
                reportBugUseCase: resolver.resolve(ReportBugUseCase.self)!
            )
        }

        // Confirm Password
        container.register(ConfirmPasswordViewModel.self) { resolver in
            ConfirmPasswordViewModel(
                compareCurrentPassswordUseCase: resolver.resolve(CompareCurrentPassswordUseCase.self)!
            )
        }
        container.register(ConfirmPasswordViewController.self) { resolver in
            ConfirmPasswordViewController(resolver.resolve(ConfirmPasswordViewModel.self)!)
        }

        // Change Password
        container.register(ChangePasswordViewModel.self) { resolver in
            ChangePasswordViewModel(changePasswordUseCase: resolver.resolve(ChangePasswordUseCase.self)!)
        }
        container.register(ChangePasswordViewController.self) { resolver in
            ChangePasswordViewController(resolver.resolve(ChangePasswordViewModel.self)!)
        }

        // Interest Field
        container.register(InterestFieldViewController.self) { resolver in
            InterestFieldViewController(
                resolver.resolve(InterestFieldViewModel.self)!
            )
        }
        container.register(InterestFieldViewModel.self) { resolver in
            InterestFieldViewModel(
                fetchCodeListUseCase: resolver.resolve(FetchCodeListUseCase.self)!,
                changeInterestsUseCase: resolver.resolve(ChangeInterestsUseCase.self)!,
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!
            )
        }
        container.register(InterestFieldCheckViewController.self) { resolver in
            InterestFieldCheckViewController(
                resolver.resolve(InterestFieldCheckViewModel.self)!
            )
        }
        container.register(InterestFieldCheckViewModel.self) { resolver in
            InterestFieldCheckViewModel(
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!
            )
        }
    }
}
