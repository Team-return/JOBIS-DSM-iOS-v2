import Foundation
import Swinject
import Core
import Domain

public final class MainPresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(HomeViewController.self) { resolver in
            HomeViewController(resolver.resolve(HomeReactor.self)!)
        }
        container.register(HomeReactor.self) { resolver in
            HomeReactor(
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!,
                fetchApplicationUseCase: resolver.resolve(FetchApplicationUseCase.self)!,
                fetchBannerListUseCase: resolver.resolve(FetchBannerListUseCase.self)!,
                fetchWinterInternUseCase: resolver.resolve(FetchWinterInternSeasonUseCase.self)!,
                fetchTotalPassStudentUseCase: resolver.resolve(FetchTotalPassStudentUseCase.self)!
            )
        }

        // Recruitment
        container.register(RecruitmentViewController.self) { resolver in
            RecruitmentViewController(resolver.resolve(RecruitmentReactor.self)!)
        }
        container.register(RecruitmentReactor.self) { resolver in
            RecruitmentReactor(
                fetchRecruitmentListUseCase: resolver.resolve(FetchRecruitmentListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }

        // Recruitment Detail
        container.register(RecruitmentDetailReactor.self) { (resolver, recruitmentID: Int?, companyId: Int?, type: RecruitmentDetailPreviousViewType) in
            RecruitmentDetailReactor(
                fetchRecruitmentDetailUseCase: resolver.resolve(FetchRecruitmentDetailUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!,
                recruitmentID: recruitmentID,
                companyId: companyId,
                type: type
            )
        }
        container.register(RecruitmentDetailViewController.self) { (resolver, recruitmentID: Int?, companyId: Int?, type: RecruitmentDetailPreviousViewType) in
            RecruitmentDetailViewController(
                resolver.resolve(RecruitmentDetailReactor.self, arguments: recruitmentID, companyId, type)!
            )
        }

        // Search Recruitment
        container.register(SearchRecruitmentViewController.self) { resolver in
            SearchRecruitmentViewController(
                resolver.resolve(SearchRecruitmentReactor.self)!
            )
        }
        container.register(SearchRecruitmentReactor.self) { resolver in
            SearchRecruitmentReactor(
                fetchRecruitmentListUseCase: resolver.resolve(FetchRecruitmentListUseCase.self)!,
                bookmarkUseCase: resolver.resolve(BookmarkUseCase.self)!
            )
        }

        // Recruitment Filter
        container.register(RecruitmentFilterViewController.self) { resolver in
            RecruitmentFilterViewController(
                resolver.resolve(RecruitmentFilterReactor.self)!
            )
        }
        container.register(RecruitmentFilterReactor.self) { resolver in
            RecruitmentFilterReactor(
                fetchCodeListUseCase: resolver.resolve(FetchCodeListUseCase.self)!
            )
        }

        // Review List
        container.register(ReviewViewController.self) { resolver in
            ReviewViewController(resolver.resolve(ReviewReactor.self)!)
        }
        container.register(ReviewReactor.self) { resolver in
            ReviewReactor(
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
                resolver.resolve(SearchReviewReactor.self)!
            )
        }
        container.register(SearchReviewReactor.self) { resolver in
            SearchReviewReactor(
                fetchReviewListUseCase: resolver.resolve(FetchReviewListUseCase.self)!
            )
        }

        // Review Filter
        container.register(ReviewFilterViewController.self) { resolver in
            ReviewFilterViewController(
                resolver.resolve(ReviewFilterReactor.self)!
            )
        }
        container.register(ReviewFilterReactor.self) { resolver in
            ReviewFilterReactor(
                fetchCodeListUseCase: resolver.resolve(FetchCodeListUseCase.self)!
            )
        }

        container.register(InterviewAtmosphereViewController.self) { resolver in
            InterviewAtmosphereViewController(
                resolver.resolve(InterviewAtmosphereViewModel.self)!
            )
        }

        container.register(InterviewAtmosphereViewModel.self) { resolver in
            InterviewAtmosphereViewModel(
                fetchReviewQuestionsUseCase: resolver.resolve(FetchReviewQuestionsUseCase.self)!
            )
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
                resolver.resolve(CompanyReactor.self)!
            )
        }
        container.register(CompanyReactor.self) { resolver in
            CompanyReactor(fetchCompanyListUseCase: resolver.resolve(FetchCompanyListUseCase.self)!)
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
                resolver.resolve(SearchCompanyReactor.self)!
            )
        }
        container.register(SearchCompanyReactor.self) { resolver in
            SearchCompanyReactor(fetchCompanyListUseCase: resolver.resolve(FetchCompanyListUseCase.self)!)
        }

        // Review
        container.register(WritableReviewViewModel.self) { resolver in
            WritableReviewViewModel()
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

        // Review Complete
        container.register(ReviewCompleteViewModel.self) { resolver in
            ReviewCompleteViewModel(
                fetchStudentInfoUseCase: resolver.resolve(FetchStudentInfoUseCase.self)!
            )
        }
        container.register(ReviewCompleteViewController.self) { resolver in
            ReviewCompleteViewController(resolver.resolve(ReviewCompleteViewModel.self)!)
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
                resolver.resolve(WinterInternReactor.self)!
            )
        }
        container.register(WinterInternReactor.self) { resolver in
            WinterInternReactor(
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
        container.register(ClassEmploymentViewController.self) { (resolver, classNumber: Int, year: Int) in
            ClassEmploymentViewController(
                viewModel: resolver.resolve(ClassEmploymentViewModel.self, arguments: classNumber, year)!,
                classNumber: classNumber,
                year: year
            )
        }
        container.register(ClassEmploymentViewModel.self) { (resolver, classNumber: Int, year: Int) in
            ClassEmploymentViewModel(
                fetchEmploymentStatusUseCase: resolver.resolve(FetchEmploymentStatusUseCase.self)!,
                classNumber: classNumber,
                year: year
            )
        }

        // Employment Filter
        container.register(EmploymentFilterViewController.self) { resolver in
            EmploymentFilterViewController(
                resolver.resolve(EmploymentFilterViewModel.self)!
            )
        }
        container.register(EmploymentFilterViewModel.self) { resolver in
            EmploymentFilterViewModel()
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
        container.register(RejectReasonReactor.self) { (
            resolver,
            applicationID: Int,
            recruitmentID: Int,
            companyName: String,
            companyImageUrl: String
        ) in
            RejectReasonReactor(
                fetchRejectionReasonUseCase: resolver.resolve(FetchRejectionReasonUseCase.self)!,
                applicationID: applicationID,
                recruitmentID: recruitmentID,
                companyName: companyName,
                companyImageUrl: companyImageUrl
            )
        }
    }
}
