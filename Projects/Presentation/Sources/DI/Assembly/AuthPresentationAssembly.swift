import Foundation
import Swinject
import Core
import Domain

public final class AuthPresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        // Onboarding
        container.register(OnboardingReactor.self) { resolver in
            OnboardingReactor(
                reissueTokenUseCase: resolver.resolve(ReissueTokenUseCase.self)!,
                fetchServerStatusUseCase: resolver.resolve(FetchServerStatusUseCase.self)!
            )
        }
        container.register(OnboardingViewController.self) { resolver in
            OnboardingViewController(resolver.resolve(OnboardingReactor.self)!)
        }

        // Info Setting
        container.register(InfoSettingReactor.self) { resolver in
            InfoSettingReactor(
                studentExistsUseCase: resolver.resolve(StudentExistsUseCase.self)!
            )
        }
        container.register(InfoSettingViewController.self) { resolver in
            InfoSettingViewController(resolver.resolve(InfoSettingReactor.self)!)
        }

        // Email Verification
        container.register(VerifyEmailReactor.self) { (resolver, name: String, gcn: Int) in
            VerifyEmailReactor(
                name: name,
                gcn: gcn,
                sendAuthCodeUseCase: resolver.resolve(SendAuthCodeUseCase.self)!,
                verifyAuthCodeUseCase: resolver.resolve(VerifyAuthCodeUseCase.self)!
            )
        }
        container.register(VerifyEmailViewController.self) { (resolver, reactor: VerifyEmailReactor) in
            VerifyEmailViewController(reactor)
        }

        // Password Setting
        container.register(PasswordSettingReactor.self) { (_, name: String, gcn: Int, email: String) in
            PasswordSettingReactor(
                name: name,
                gcn: gcn,
                email: email
            )
        }
        container.register(PasswordSettingViewController.self) { (_, reactor: PasswordSettingReactor) in
            PasswordSettingViewController(reactor)
        }

        // Gender Setting
        container.register(GenderSettingReactor.self) { (_, name: String, gcn: Int, email: String, password: String) in
            GenderSettingReactor(
                name: name,
                gcn: gcn,
                email: email,
                password: password
            )
        }
        container.register(GenderSettingViewController.self) { (_, reactor: GenderSettingReactor) in
            GenderSettingViewController(reactor)
        }

        // Profile Setting
        container.register(ProfileSettingReactor.self) { (resolver, name: String, gcn: Int, email: String, password: String, isMan: Bool) in
            ProfileSettingReactor(
                name: name,
                gcn: gcn,
                email: email,
                password: password,
                isMan: isMan,
                fetchPresignedURLUseCase: resolver.resolve(FetchPresignedURLUseCase.self)!,
                uploadImageToS3UseCase: resolver.resolve(UploadImageToS3UseCase.self)!
            )
        }
        container.register(ProfileSettingViewController.self) { (_, reactor: ProfileSettingReactor) in
            ProfileSettingViewController(reactor)
        }

        // Privacy
        container.register(PrivacyReactor.self) { (resolver, name: String, gcn: Int, email: String, password: String, isMan: Bool, profileImageURL: String?) in
            PrivacyReactor(
                name: name,
                gcn: gcn,
                email: email,
                password: password,
                isMan: isMan,
                profileImageURL: profileImageURL,
                signupUseCase: resolver.resolve(SignupUseCase.self)!
            )
        }
        container.register(PrivacyViewController.self) { (_, reactor: PrivacyReactor) in
            PrivacyViewController(reactor)
        }

        // Signin
        container.register(SigninReactor.self) { resolver in
            SigninReactor(signinUseCase: resolver.resolve(SigninUseCase.self)!)
        }
        container.register(SigninViewController.self) { resolver in
            SigninViewController(resolver.resolve(SigninReactor.self)!)
        }

        // Confirm Email
        container.register(ConfirmEmailReactor.self) { resolver in
            ConfirmEmailReactor(
                sendAuthCodeUseCase: resolver.resolve(SendAuthCodeUseCase.self)!,
                verifyAuthCodeUseCase: resolver.resolve(VerifyAuthCodeUseCase.self)!
            )
        }
        container.register(ConfirmEmailViewController.self) { resolver in
            ConfirmEmailViewController(resolver.resolve(ConfirmEmailReactor.self)!)
        }

        // Password Renewal
        container.register(RenewalPasswordReactor.self) { (resolver, email: String) in
            RenewalPasswordReactor(
                renewalPasswordUseCase: resolver.resolve(RenewalPasswordUseCase.self)!,
                email: email
            )
        }
    }
}
