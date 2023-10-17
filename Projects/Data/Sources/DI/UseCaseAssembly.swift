import Foundation
import Swinject
import Domain

public final class UseCaseAssembly: Assembly {
    public init() {}

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
}
