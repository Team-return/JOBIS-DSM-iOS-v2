import Foundation
import Swinject
import Core
import Domain

public final class SettingPresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(MyPageReactor.self) { resolver in
            MyPageReactor(
                fetchPresignedURLUseCase: resolver.resolve(FetchPresignedURLUseCase.self)!,
                uploadImageToS3UseCase: resolver.resolve(UploadImageToS3UseCase.self)!,
                changeProfileImageUseCase: resolver.resolve(ChangeProfileImageUseCase.self)!,
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!,
                fetchWritableReviewListUseCase: resolver.resolve(FetchWritableReviewListUseCase.self)!,
                logoutUseCase: resolver.resolve(LogoutUseCase.self)!,
                deleteDeviceTokenUseCase: resolver.resolve(DeleteDeviceTokenUseCase.self)!
            )
        }
        container.register(MyPageViewController.self) { resolver in
            MyPageViewController(resolver.resolve(MyPageReactor.self)!)
        }

        // Bookmark
        container.register(BookmarkReactor.self) { resolver in
            BookmarkReactor(
                fetchBookmarkListUseCase: resolver.resolve(FetchBookmarkListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }
        container.register(BookmarkViewController.self) { resolver in
            BookmarkViewController(resolver.resolve(BookmarkReactor.self)!)
        }

        // Alarm
        container.register(AlarmViewController.self) { resolver in
            AlarmViewController(resolver.resolve(AlarmReactor.self)!)
        }
        container.register(AlarmReactor.self) { resolver in
            AlarmReactor(
                fetchNotificationListUseCase: resolver.resolve(FetchNotificationListUseCase.self)!,
                readNotificationUseCase: resolver.resolve(ReadNotificationUseCase.self)!
            )
        }

        // Notification Setting
        container.register(NotificationSettingReactor.self) { resolver in
            NotificationSettingReactor(
                subscribeNotificationUseCase: resolver.resolve(SubscribeNotificationUseCase.self)!,
                subscribeAllNotificationUseCase: resolver.resolve(SubscribeAllNotificationUseCase.self)!,
                fetchSubscribeStateUseCase: resolver.resolve(FetchSubscribeStateUseCase.self)!
            )
        }
        container.register(NotificationSettingViewController.self) { resolver in
            NotificationSettingViewController(resolver.resolve(NotificationSettingReactor.self)!)
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
        container.register(NoticeDetailReactor.self) { (resolver: Resolver, noticeID: Int) in
            NoticeDetailReactor(
                noticeID: noticeID,
                fetchNoticeDetailUseCase: resolver.resolve(FetchNoticeDetailUseCase.self)!
            )
        }
        container.register(NoticeDetailViewController.self) { (resolver: Resolver, noticeID: Int) in
            NoticeDetailViewController(resolver.resolve(NoticeDetailReactor.self, argument: noticeID)!)
        }

        // Bug Report
        container.register(BugReportViewController.self) { resolver in
            BugReportViewController(resolver.resolve(BugReportReactor.self)!)
        }
        container.register(BugReportReactor.self) { resolver in
            BugReportReactor(
                reportBugUseCase: resolver.resolve(ReportBugUseCase.self)!
            )
        }

        // Confirm Password
        container.register(ConfirmPasswordReactor.self) { resolver in
            ConfirmPasswordReactor(
                compareCurrentPassswordUseCase: resolver.resolve(CompareCurrentPassswordUseCase.self)!
            )
        }
        container.register(ConfirmPasswordViewController.self) { resolver in
            ConfirmPasswordViewController(resolver.resolve(ConfirmPasswordReactor.self)!)
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
                resolver.resolve(InterestFieldReactor.self)!
            )
        }
        container.register(InterestFieldReactor.self) { resolver in
            InterestFieldReactor(
                fetchCodeListUseCase: resolver.resolve(FetchCodeListUseCase.self)!,
                changeInterestsUseCase: resolver.resolve(ChangeInterestsUseCase.self)!,
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!
            )
        }
        container.register(InterestFieldCheckViewController.self) { resolver in
            InterestFieldCheckViewController(
                resolver.resolve(InterestFieldCheckReactor.self)!
            )
        }
        container.register(InterestFieldCheckReactor.self) { resolver in
            InterestFieldCheckReactor(
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!
            )
        }
    }
}
