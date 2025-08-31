import Foundation
import Swinject
import Core
import Domain

public final class AuthPresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        // Onboarding
        container.register(OnboardingViewModel.self) { resolver in
            OnboardingViewModel(
                reissueTokenUaseCase: resolver.resolve(ReissueTokenUaseCase.self)!,
                fetchServerStatusUseCase: resolver.resolve(FetchServerStatusUseCase.self)!
            )
        }
        container.register(OnboardingViewController.self) { resolver in
            OnboardingViewController(resolver.resolve(OnboardingViewModel.self)!)
        }

        // Info Setting
        container.register(InfoSettingViewModel.self) { resolver in
            InfoSettingViewModel(
                studentExistsUseCase: resolver.resolve(StudentExistsUseCase.self)!
            )
        }
        container.register(InfoSettingViewController.self) { resolver in
            InfoSettingViewController(resolver.resolve(InfoSettingViewModel.self)!)
        }

        // Email Verification
        container.register(VerifyEmailViewModel.self) { resolver in
            VerifyEmailViewModel(
                sendAuthCodeUseCase: resolver.resolve(SendAuthCodeUseCase.self)!,
                verifyAuthCodeUseCase: resolver.resolve(VerifyAuthCodeUseCase.self)!
            )
        }
        container.register(VerifyEmailViewController.self) { resolver in
            VerifyEmailViewController(resolver.resolve(VerifyEmailViewModel.self)!)
        }

        // Password Setting
        container.register(PasswordSettingViewModel.self) { _ in
            PasswordSettingViewModel()
        }
        container.register(PasswordSettingViewController.self) { resolver in
            PasswordSettingViewController(resolver.resolve(PasswordSettingViewModel.self)!)
        }

        // Gender Setting
        container.register(GenderSettingViewModel.self) { _ in
            GenderSettingViewModel()
        }
        container.register(GenderSettingViewController.self) { resolver in
            GenderSettingViewController(resolver.resolve(GenderSettingViewModel.self)!)
        }

        // Profile Setting
        container.register(ProfileSettingViewModel.self) { resolver in
            ProfileSettingViewModel(
                fetchPresignedURLUseCase: resolver.resolve(FetchPresignedURLUseCase.self)!,
                uploadImageToS3UseCase: resolver.resolve(UploadImageToS3UseCase.self)!
            )
        }
        container.register(ProfileSettingViewController.self) { resolver in
            ProfileSettingViewController(resolver.resolve(ProfileSettingViewModel.self)!)
        }

        // Privacy
        container.register(PrivacyViewModel.self) { resolver in
            PrivacyViewModel(signupUseCase: resolver.resolve(SignupUseCase.self)!)
        }
        container.register(PrivacyViewController.self) { resolver in
            PrivacyViewController(resolver.resolve(PrivacyViewModel.self)!)
        }

        // Signin
        container.register(SigninReactor.self) { resolver in
            SigninReactor(signinUseCase: resolver.resolve(SigninUseCase.self)!)
        }
        container.register(SigninViewController.self) { resolver in
            SigninViewController(resolver.resolve(SigninReactor.self)!)
        }

        // Confirm Email
        container.register(ConfirmEmailViewModel.self) { resolver in
            ConfirmEmailViewModel(
                sendAuthCodeUseCase: resolver.resolve(SendAuthCodeUseCase.self)!,
                verifyAuthCodeUseCase: resolver.resolve(VerifyAuthCodeUseCase.self)!
            )
        }
        container.register(ConfirmEmailViewController.self) { resolver in
            ConfirmEmailViewController(resolver.resolve(ConfirmEmailViewModel.self)!)
        }

        // Password Renewal
        container.register(RenewalPasswordViewModel.self) { resolver in
            RenewalPasswordViewModel(
                renewalPasswordUseCase: resolver.resolve(RenewalPasswordUseCase.self)!
            )
        }
        container.register(RenewalPasswordViewController.self) { resolver in
            RenewalPasswordViewController(resolver.resolve(RenewalPasswordViewModel.self)!)
        }
    }
}
