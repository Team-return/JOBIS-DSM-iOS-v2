import Foundation
import Swinject
import Core
import Domain

public final class PresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(HomeViewController.self) { resolver in
            HomeViewController(resolver.resolve(HomeViewModel.self)!)
        }
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!,
                fetchApplicationUseCase: resolver.resolve(FetchApplicationUseCase.self)!,
                fetchBannerListUseCase: resolver.resolve(FetchBannerListUseCase.self)!
            )
        }

        container.register(AlarmViewController.self) { resolver in
            AlarmViewController(resolver.resolve(AlarmViewModel.self)!)
        }
        container.register(AlarmViewModel.self) { resolver in
            AlarmViewModel(
                fetchNotificationListUseCase: resolver.resolve(FetchNotificationListUseCase.self)!,
                readNotificationUseCase: resolver.resolve(ReadNotificationUseCase.self)!
            )
        }

        container.register(RecruitmentViewController.self) { resolver in
            RecruitmentViewController(resolver.resolve(RecruitmentViewModel.self)!)
        }

        container.register(RecruitmentViewModel.self) { resolver in
            RecruitmentViewModel(
                fetchRecruitmentListUseCase: resolver.resolve(FetchRecruitmentListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }

        container.register(BookmarkViewController.self) { resolver in
            BookmarkViewController(resolver.resolve(BookmarkViewModel.self)!)
        }
        container.register(BookmarkViewModel.self) { resolver in
            BookmarkViewModel(
                fetchBookmarkListUseCase: resolver.resolve(FetchBookmarkListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }

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
                logoutUseCase: resolver.resolve(LogoutUseCase.self)!
            )
        }

        container.register(OnboardingViewModel.self) { resolver in
            OnboardingViewModel(
                reissueTokenUaseCase: resolver.resolve(ReissueTokenUaseCase.self)!
            )
        }
        container.register(OnboardingViewController.self) { resolver in
            OnboardingViewController(resolver.resolve(OnboardingViewModel.self)!)
        }

        container.register(InfoSettingViewModel.self) { resolver in
            InfoSettingViewModel(
                studentExistsUseCase: resolver.resolve(StudentExistsUseCase.self)!
            )
        }
        container.register(InfoSettingViewController.self) { resolver in
            InfoSettingViewController(resolver.resolve(InfoSettingViewModel.self)!)
        }

        container.register(VerifyEmailViewModel.self) { resolver in
            VerifyEmailViewModel(
                sendAuthCodeUseCase: resolver.resolve(SendAuthCodeUseCase.self)!,
                verifyAuthCodeUseCase: resolver.resolve(VerifyAuthCodeUseCase.self)!
            )
        }
        container.register(VerifyEmailViewController.self) { resolver in
            VerifyEmailViewController(resolver.resolve(VerifyEmailViewModel.self)!)
        }

        container.register(PasswordSettingViewModel.self) { _ in
            PasswordSettingViewModel()
        }
        container.register(PasswordSettingViewController.self) { resolver in
            PasswordSettingViewController(resolver.resolve(PasswordSettingViewModel.self)!)
        }

        container.register(GenderSettingViewModel.self) { _ in
            GenderSettingViewModel()
        }
        container.register(GenderSettingViewController.self) { resolver in
            GenderSettingViewController(resolver.resolve(GenderSettingViewModel.self)!)
        }

        container.register(ProfileSettingViewModel.self) { resolver in
            ProfileSettingViewModel(
                fetchPresignedURLUseCase: resolver.resolve(FetchPresignedURLUseCase.self)!,
                uploadImageToS3UseCase: resolver.resolve(UploadImageToS3UseCase.self)!
            )
        }
        container.register(ProfileSettingViewController.self) { resolver in
            ProfileSettingViewController(resolver.resolve(ProfileSettingViewModel.self)!)
        }

        container.register(PrivacyViewModel.self) { resolver in
            PrivacyViewModel(signupUseCase: resolver.resolve(SignupUseCase.self)!)
        }
        container.register(PrivacyViewController.self) { resolver in
            PrivacyViewController(resolver.resolve(PrivacyViewModel.self)!)
        }

        container.register(SigninReactor.self) { resolver in
            SigninReactor(signinUseCase: resolver.resolve(SigninUseCase.self)!)
        }
        container.register(SigninViewController.self) { resolver in
            SigninViewController(resolver.resolve(SigninReactor.self)!)
        }

        container.register(ConfirmEmailViewModel.self) { resolver in
            ConfirmEmailViewModel(
                sendAuthCodeUseCase: resolver.resolve(SendAuthCodeUseCase.self)!,
                verifyAuthCodeUseCase: resolver.resolve(VerifyAuthCodeUseCase.self)!
            )
        }
        container.register(ConfirmEmailViewController.self) { resolver in
            ConfirmEmailViewController(resolver.resolve(ConfirmEmailViewModel.self)!)
        }

        container.register(RenewalPasswordViewModel.self) { resolver in
            RenewalPasswordViewModel(
                renewalPasswordUseCase: resolver.resolve(RenewalPasswordUseCase.self)!
            )
        }
        container.register(RenewalPasswordViewController.self) { resolver in
            RenewalPasswordViewController(resolver.resolve(RenewalPasswordViewModel.self)!)
        }

        container.register(NoticeViewModel.self) { resolver in
            NoticeViewModel(
                fetchNoticeListUseCase: resolver.resolve(FetchNoticeListUseCase.self)!
            )
        }

        container.register(NoticeViewController.self) { resolver in
            NoticeViewController(resolver.resolve(NoticeViewModel.self)!)
        }

        container.register(NoticeDetailViewModel.self) { resolver in
            NoticeDetailViewModel(
                fetchNoticeDetailUseCase: resolver.resolve(FetchNoticeDetailUseCase.self)!
            )
        }

        container.register(NoticeDetailViewController.self) { resolver in
            NoticeDetailViewController(resolver.resolve(NoticeDetailViewModel.self)!)
        }

        container.register(ConfirmPasswordViewModel.self) { resolver in
            ConfirmPasswordViewModel(
                compareCurrentPassswordUseCase: resolver.resolve(CompareCurrentPassswordUseCase.self)!
            )
        }
        container.register(ConfirmPasswordViewController.self) { resolver in
            ConfirmPasswordViewController(resolver.resolve(ConfirmPasswordViewModel.self)!)
        }

        container.register(ChangePasswordViewModel.self) { resolver in
            ChangePasswordViewModel(changePasswordUseCase: resolver.resolve(ChangePasswordUseCase.self)!)
        }
        container.register(ChangePasswordViewController.self) { resolver in
            ChangePasswordViewController(resolver.resolve(ChangePasswordViewModel.self)!)
        }

        container.register(CompanyDetailViewModel.self) { resolver in
            CompanyDetailViewModel(
                fetchCompanyInfoDetailUseCase: resolver.resolve(FetchCompanyInfoDetailUseCase.self)!,
                fetchReviewListUseCase: resolver.resolve(FetchReviewListUseCase.self)!
            )
        }
        container.register(CompanyDetailViewController.self) { resolver in
            CompanyDetailViewController(resolver.resolve(CompanyDetailViewModel.self)!)
        }

        container.register(RecruitmentDetailViewModel.self) { resolver in
            RecruitmentDetailViewModel(
                fetchRecruitmentDetailUseCase: resolver.resolve(FetchRecruitmentDetailUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }
        container.register(RecruitmentDetailViewController.self) { resolver in
            RecruitmentDetailViewController(
                resolver.resolve(RecruitmentDetailViewModel.self)!
            )
        }

        container.register(ApplyViewModel.self) { resolver in
            ApplyViewModel(
                applyCompanyUseCase: resolver.resolve(ApplyCompanyUseCase.self)!,
                reApplyCompanyUseCase: resolver.resolve(ReApplyCompanyUseCase.self)!
            )
        }
        container.register(ApplyViewController.self) { resolver in
            ApplyViewController(resolver.resolve(ApplyViewModel.self)!)
        }

        container.register(CompanyViewController.self) { resolver in
            CompanyViewController(
                resolver.resolve(CompanyViewModel.self)!
            )
        }
        container.register(CompanyViewModel.self) { resolver in
            CompanyViewModel(fetchCompanyListUseCase: resolver.resolve(FetchCompanyListUseCase.self)!)
        }

        container.register(RecruitmentSearchViewController.self) { resolver in
            RecruitmentSearchViewController(
                resolver.resolve(RecruitmentSearchViewModel.self)!
            )
        }
        container.register(RecruitmentSearchViewModel.self) { resolver in
            RecruitmentSearchViewModel(
                fetchRecruitmentListUseCase: resolver.resolve(FetchRecruitmentListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }

        container.register(RejectReasonViewModel.self) { resolver in
            RejectReasonViewModel(
                fetchRejectionReasonUseCase: resolver.resolve(FetchRejectionReasonUseCase.self)!
            )
        }

        container.register(EasterEggViewController.self) { resolver in
            EasterEggViewController()
        }
    }
}
