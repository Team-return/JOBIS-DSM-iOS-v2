import Foundation
import Swinject
import Domain

public final class UseCaseAssembly: Assembly {
    public init() {}

// swiftlint:disable function_body_length
    public func assemble(container: Container) {
        // Auth
        container.register(SendAuthCodeUseCase.self) { resolver in
            SendAuthCodeUseCase(
                authRepository: resolver.resolve(AuthRepository.self)!
            )
        }
        container.register(VerifyAuthCodeUseCase.self) { resolver in
            VerifyAuthCodeUseCase(
                authRepository: resolver.resolve(AuthRepository.self)!
            )
        }
        container.register(ReissueTokenUaseCase.self) { resolver in
            ReissueTokenUaseCase(
                authRepository: resolver.resolve(AuthRepository.self)!
            )
        }

        // Users
        container.register(SigninUseCase.self) { resolver in
            SigninUseCase(
                usersRepository: resolver.resolve(UsersRepository.self)!
            )
        }
        container.register(LogoutUseCase.self) { resolver in
            LogoutUseCase(
                usersRepository: resolver.resolve(UsersRepository.self)!
            )
        }

        // Students
        container.register(ChangePasswordUseCase.self) { reslover in
            ChangePasswordUseCase(
                studentsRepository: reslover.resolve(StudentsRepository.self)!
            )
        }
        container.register(ChangeProfileImageUseCase.self) { reslover in
            ChangeProfileImageUseCase(
                studentsRepository: reslover.resolve(StudentsRepository.self)!
            )
        }
        container.register(CompareCurrentPassswordUseCase.self) { reslover in
            CompareCurrentPassswordUseCase(
                studentsRepository: reslover.resolve(StudentsRepository.self)!
            )
        }
        container.register(FetchStudentInfoUseCase.self) { reslover in
            FetchStudentInfoUseCase(
                studentsRepository: reslover.resolve(StudentsRepository.self)!
            )
        }
        container.register(RenewalPasswordUseCase.self) { reslover in
            RenewalPasswordUseCase(
                studentsRepository: reslover.resolve(StudentsRepository.self)!
            )
        }
        container.register(SignupUseCase.self) { reslover in
            SignupUseCase(
                studentsRepository: reslover.resolve(StudentsRepository.self)!
            )
        }
        container.register(StudentExistsUseCase.self) { reslover in
            StudentExistsUseCase(
                studentsRepository: reslover.resolve(StudentsRepository.self)!
            )
        }

        // Companies
        container.register(FetchCompanyListUseCase.self) { resolver in
            FetchCompanyListUseCase(
                companiesRepository: resolver.resolve(CompaniesRepository.self)!
            )
        }
        container.register(FetchCompanyInfoDetailUseCase.self) { resolver in
            FetchCompanyInfoDetailUseCase(
                companiesRepository: resolver.resolve(CompaniesRepository.self)!
            )
        }
        container.register(FetchWritableReviewListUseCase.self) { resolver in
            FetchWritableReviewListUseCase(
                companiesRepository: resolver.resolve(CompaniesRepository.self)!
            )
        }

        // Reviews
        container.register(FetchReviewListUseCase.self) { resolver in
            FetchReviewListUseCase(
                reviewsRepository: resolver.resolve(ReviewsRepository.self)!
            )
        }
        container.register(FetchReviewDetailUseCase.self) { resolver in
            FetchReviewDetailUseCase(
                reviewsRepository: resolver.resolve(ReviewsRepository.self)!
            )
        }
        container.register(PostReviewUseCase.self) { resolver in
            PostReviewUseCase(
                reviewsRepository: resolver.resolve(ReviewsRepository.self)!
            )
        }

        // Applications
        container.register(ApplyCompanyUseCase.self) { resolver in
            ApplyCompanyUseCase(
                applicationsRepository: resolver.resolve(ApplicationsRepository.self)!
            )
        }
        container.register(ReApplyCompanyUseCase.self) { resolver in
            ReApplyCompanyUseCase(
                applicationsRepository: resolver.resolve(ApplicationsRepository.self)!
            )
        }
        container.register(CancelApplyUseCase.self) { resolver in
            CancelApplyUseCase(
                applicationsRepository: resolver.resolve(ApplicationsRepository.self)!
            )
        }
        container.register(FetchApplicationUseCase.self) { resolver in
            FetchApplicationUseCase(
                applicationsRepository: resolver.resolve(ApplicationsRepository.self)!
            )
        }
        container.register(FetchTotalPassStudentUseCase.self) { resolver in
            FetchTotalPassStudentUseCase(
                applicationsRepository: resolver.resolve(ApplicationsRepository.self)!
            )
        }
        container.register(FetchRejectionReasonUseCase.self) { resolver in
            FetchRejectionReasonUseCase(
                applicationsRepository: resolver.resolve(ApplicationsRepository.self)!
            )
        }

        // Bugs
        container.register(ReportBugUseCase.self) { resolver in
            ReportBugUseCase(
                bugsRepository: resolver.resolve(BugsRepository.self)!
            )
        }
        container.register(FetchBugListUseCase.self) { resolver in
            FetchBugListUseCase(
                bugsRepository: resolver.resolve(BugsRepository.self)!
            )
        }
        container.register(FetchBugDetailUseCase.self) { resolver in
            FetchBugDetailUseCase(
                bugsRepository: resolver.resolve(BugsRepository.self)!
            )
        }

        // Bookmarks
        container.register(FetchBookmarkListUseCase.self) { resolver in
            FetchBookmarkListUseCase(
                bookmarksRepository: resolver.resolve(BookmarksRepository.self)!
            )
        }
        container.register(BookmarkUseCase.self) { resolver in
            BookmarkUseCase(
                bookmarksRepository: resolver.resolve(BookmarksRepository.self)!
            )
        }

        // Recruitments
        container.register(FetchRecruitmentListUseCase.self) { resolver in
            FetchRecruitmentListUseCase(
                recruitmentsRepository: resolver.resolve(RecruitmentsRepository.self)!
            )
        }
        container.register(FetchRecruitmentDetailUseCase.self) { resolver in
            FetchRecruitmentDetailUseCase(
                recruitmentsRepository: resolver.resolve(RecruitmentsRepository.self)!
            )
        }

        // Codes
        container.register(FetchCodeListUseCase.self) { resolver in
            FetchCodeListUseCase(
                codesRepository: resolver.resolve(CodesRepository.self)!
            )
        }

        // Files
        container.register(FetchPresignedURLUseCase.self) { resolver in
            FetchPresignedURLUseCase(
                filesRepository: resolver.resolve(FilesRepository.self)!
            )
        }
        container.register(UploadImageToS3UseCase.self) { resolver in
            UploadImageToS3UseCase(
                presignedURLRepository: resolver.resolve(PresignedURLRepository.self)!
            )
        }

        // Banners
        container.register(FetchBannerListUseCase.self) { resolver in
            FetchBannerListUseCase(
                bannersRepository: resolver.resolve(BannersRepository.self)!
            )
        }
    }
    // swiftlint:enable function_body_length
}
