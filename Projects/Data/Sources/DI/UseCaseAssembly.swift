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
            StudentExistsUseCase(studentsRepository: reslover.resolve(StudentsRepository.self)!

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
    }
    // swiftlint:enable function_body_length
}
