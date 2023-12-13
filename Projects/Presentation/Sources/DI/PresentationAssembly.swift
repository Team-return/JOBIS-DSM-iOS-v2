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
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!
            )
        }

        container.register(AlarmViewController.self) { resolver in
            AlarmViewController(resolver.resolve(AlarmViewModel.self)!)
        }
        container.register(AlarmViewModel.self) { resolver in
            AlarmViewModel(
//                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!
            )
        }

        container.register(RecruitmentViewController.self) { resolver in
            RecruitmentViewController(resolver.resolve(RecruitmentViewModel.self)!)
        }
        container.register(RecruitmentViewModel.self) { resolver in
            RecruitmentViewModel()
        }

        container.register(BookmarkViewController.self) { resolver in
            BookmarkViewController(resolver.resolve(BookmarkViewModel.self)!)
        }
        container.register(BookmarkViewModel.self) { resolver in
            BookmarkViewModel()
        }

        container.register(MyPageViewController.self) { resolver in
            MyPageViewController(resolver.resolve(MyPageViewModel.self)!)
        }
        container.register(MyPageViewModel.self) { resolver in
            MyPageViewModel(
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!,
                fetchWritableReviewListUseCase: resolver.resolve(FetchWritableReviewListUseCase.self)!
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

        container.register(PrivacyViewModel.self) { resolver in
            PrivacyViewModel(signupUseCase: resolver.resolve(SignupUseCase.self)!)
        }
        container.register(PrivacyViewController.self) { resolver in
            PrivacyViewController(resolver.resolve(PrivacyViewModel.self)!)
        }

        container.register(SigninViewModel.self) { resolver in
            SigninViewModel(signinUseCase: resolver.resolve(SigninUseCase.self)!)
        }
        container.register(SigninViewController.self) { resolver in
            SigninViewController(resolver.resolve(SigninViewModel.self)!)
        }
    }
}
