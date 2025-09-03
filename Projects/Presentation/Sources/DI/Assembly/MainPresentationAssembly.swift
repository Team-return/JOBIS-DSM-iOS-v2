import Foundation
import Swinject
import Core
import Domain

public final class MainPresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(HomeViewController.self) { resolver in
            HomeViewController(resolver.resolve(HomeViewModel.self)!)
        }
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!,
                fetchApplicationUseCase: resolver.resolve(FetchApplicationUseCase.self)!,
                fetchBannerListUseCase: resolver.resolve(FetchBannerListUseCase.self)!,
                fetchWinterInternUseCase: resolver.resolve(FetchWinterInternSeasonUseCase.self)!,
                fetchTotalPassStudentUseCase: resolver.resolve(FetchTotalPassStudentUseCase.self)!
            )
        }

        // Recruitment
        container.register(RecruitmentViewController.self) { resolver in
            RecruitmentViewController(resolver.resolve(RecruitmentViewModel.self)!)
        }
        container.register(RecruitmentViewModel.self) { resolver in
            RecruitmentViewModel(
                fetchRecruitmentListUseCase: resolver.resolve(FetchRecruitmentListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }

        // Recruitment Detail
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

        // Search Recruitment
        container.register(SearchRecruitmentViewController.self) { resolver in
            SearchRecruitmentViewController(
                resolver.resolve(SearchRecruitmentViewModel.self)!
            )
        }
        container.register(SearchRecruitmentViewModel.self) { resolver in
            SearchRecruitmentViewModel(
                fetchRecruitmentListUseCase: resolver.resolve(FetchRecruitmentListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }

        // Recruitment Filter
        container.register(RecruitmentFilterViewController.self) { resolver in
            RecruitmentFilterViewController(
                resolver.resolve(RecruitmentFilterViewModel.self)!
            )
        }
        container.register(RecruitmentFilterViewModel.self) { resolver in
            RecruitmentFilterViewModel(
                fetchCodeListUseCase: resolver.resolve(FetchCodeListUseCase.self)!
            )
        }

        // Review List
        container.register(ReviewViewController.self) { resolver in
            ReviewViewController(resolver.resolve(ReviewViewModel.self)!)
        }
        container.register(ReviewViewModel.self) { resolver in
            ReviewViewModel(
                fetchReviewListUseCase: resolver.resolve(FetchReviewListUseCase.self)!
            )
        }

        // Review Detail
        container.register(ReviewDetailViewController.self) { resolver in
            ReviewDetailViewController(
                resolver.resolve(ReviewDetailViewModel.self)!
            )
        }
        container.register(ReviewDetailViewModel.self) { resolver in
            ReviewDetailViewModel(
                fetchReviewDetailUseCase: resolver.resolve(FetchReviewDetailUseCase.self)!
            )
        }

        // Search Review List
        container.register(SearchReviewViewController.self) { resolver in
            SearchReviewViewController(
                resolver.resolve(SearchReviewViewModel.self)!
            )
        }
        container.register(SearchReviewViewModel.self) { resolver in
            SearchReviewViewModel(
                fetchReviewListUseCase: resolver.resolve(FetchReviewListUseCase.self)!
            )
        }

        // Review Filter
        container.register(ReviewFilterViewController.self) { resolver in
            ReviewFilterViewController(
                resolver.resolve(ReviewFilterViewModel.self)!
            )
        }
        container.register(ReviewFilterViewModel.self) { resolver in
            ReviewFilterViewModel()
        }

        // Apply
        container.register(ApplyViewModel.self) { resolver in
            ApplyViewModel(
                applyCompanyUseCase: resolver.resolve(ApplyCompanyUseCase.self)!,
                reApplyCompanyUseCase: resolver.resolve(ReApplyCompanyUseCase.self)!
            )
        }
        container.register(ApplyViewController.self) { resolver in
            ApplyViewController(resolver.resolve(ApplyViewModel.self)!)
        }

        // Company
        container.register(CompanyViewController.self) { resolver in
            CompanyViewController(
                resolver.resolve(CompanyViewModel.self)!
            )
        }
        container.register(CompanyViewModel.self) { resolver in
            CompanyViewModel(fetchCompanyListUseCase: resolver.resolve(FetchCompanyListUseCase.self)!)
        }

        // Company Detail
        container.register(CompanyDetailViewModel.self) { resolver in
            CompanyDetailViewModel(
                fetchCompanyInfoDetailUseCase: resolver.resolve(FetchCompanyInfoDetailUseCase.self)!,
                fetchReviewListUseCase: resolver.resolve(FetchReviewListUseCase.self)!
            )
        }
        container.register(CompanyDetailViewController.self) { resolver in
            CompanyDetailViewController(resolver.resolve(CompanyDetailViewModel.self)!)
        }

        // Search Company
        container.register(SearchCompanyViewController.self) { resolver in
            SearchCompanyViewController(
                resolver.resolve(SearchCompanyViewModel.self)!
            )
        }
        container.register(SearchCompanyViewModel.self) { resolver in
            SearchCompanyViewModel(fetchCompanyListUseCase: resolver.resolve(FetchCompanyListUseCase.self)!)
        }

        // Review
        container.register(WritableReviewViewModel.self) { resolver in
            WritableReviewViewModel(
                postReviewUseCase: resolver.resolve(PostReviewUseCase.self)!
            )
        }
        container.register(WritableReviewViewController.self) { resolver in
            WritableReviewViewController(resolver.resolve(WritableReviewViewModel.self)!)
        }

        // Add Review
        container.register(AddReviewViewModel.self) { resolver in
            AddReviewViewModel(
                fetchCodeListUseCase: resolver.resolve(FetchCodeListUseCase.self)!
            )
        }
        container.register(AddReviewViewController.self) { resolver in
            AddReviewViewController(resolver.resolve(AddReviewViewModel.self)!)
        }

        // Interview Review Detail
        container.register(InterviewReviewDetailViewModel.self) { resolver in
            InterviewReviewDetailViewModel(
                fetchReviewDetailUseCase: resolver.resolve(FetchReviewDetailUseCase.self)!
            )
        }
        container.register(InterviewReviewDetailViewController.self) { resolver in
            InterviewReviewDetailViewController(resolver.resolve(InterviewReviewDetailViewModel.self)!)
        }

        // Winter Intern
        container.register(WinterInternViewController.self) { resolver in
            WinterInternViewController(
                resolver.resolve(WinterInternVieModel.self)!
            )
        }
        container.register(WinterInternVieModel.self) { resolver in
            WinterInternVieModel(
                fetchRecruitmentListUseCase: resolver.resolve(FetchRecruitmentListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }
        container.register(WinterInternDetailViewController.self) { resolver in
            WinterInternDetailViewController(
                resolver.resolve(WinterInternDetailViewModel.self)!
            )
        }
        container.register(WinterInternDetailViewModel.self) { resolver in
            WinterInternDetailViewModel(
                fetchRecruitmentDetailUseCase: resolver.resolve(FetchRecruitmentDetailUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }

        // Employ Status
        container.register(EmployStatusViewController.self) { resolver in
            EmployStatusViewController(
                resolver.resolve(EmployStatusViewModel.self)!
            )
        }
        container.register(EmployStatusViewModel.self) { resolver in
            EmployStatusViewModel(
                fetchTotalPassStudentUseCase: resolver.resolve(FetchTotalPassStudentUseCase.self)!
            )
        }

        // Class Employment
        container.register(ClassEmploymentViewController.self) { (resolver, classNumber: Int) in
            ClassEmploymentViewController(
                viewModel: resolver.resolve(ClassEmploymentViewModel.self, argument: classNumber)!,
                classNumber: classNumber
            )
        }
        container.register(ClassEmploymentViewModel.self) { (resolver, classNumber: Int) in
            ClassEmploymentViewModel(
                fetchEmploymentStatusUseCase: resolver.resolve(FetchEmploymentStatusUseCase.self)!,
                classNumber: classNumber
            )
        }

        // Easter Egg
        container.register(EasterEggViewController.self) { resolver in
            EasterEggViewController()
        }

        // Major Bottom Sheet
        container.register(MajorBottomSheetViewController.self) { resolver in
            MajorBottomSheetViewController(
                resolver.resolve(MajorBottomSheetViewModel.self)!
            )
        }
        container.register(MajorBottomSheetViewModel.self) { resolver in
            MajorBottomSheetViewModel()
        }

        // Reject Reason
        container.register(RejectReasonViewModel.self) { resolver in
            RejectReasonViewModel(
                fetchRejectionReasonUseCase: resolver.resolve(FetchRejectionReasonUseCase.self)!
            )
        }
    }
}
