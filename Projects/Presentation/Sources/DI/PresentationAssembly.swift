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
                signinUseCase: resolver.resolve(SigninUseCase.self)!,
                reissueTokenUseCase: resolver.resolve(ReissueTokenUaseCase.self)!
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

        container.register(SignupViewModel.self) { resolver in
            SignupViewModel()
        }
        container.register(SignupViewController.self) { resolver in
            SignupViewController(resolver.resolve(SignupViewModel.self)!)
        }

        container.register(SigninViewModel.self) { resolver in
            SigninViewModel(signinUseCase: resolver.resolve(SigninUseCase.self)!)
        }
        container.register(SigninViewController.self) { resolver in
            SigninViewController(resolver.resolve(SigninViewModel.self)!)
        }
    }
}
