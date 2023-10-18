import Foundation
import Swinject
import Domain

public final class RepositoryAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(AuthRepository.self) { resolver in
            AuthRepositoryImpl(authRemote: resolver.resolve(AuthRemote.self)!)
        }

        container.register(UsersRepository.self) { resolver in
            UsersRepositoryImpl(usersRemote: resolver.resolve(UsersRemote.self)!)
        }

        container.register(StudentsRepository.self) { reslover in
            StudentsRepositoryImpl(studentsRemote: reslover.resolve(StudentsRemote.self)!)
        }

        container.register(CompaniesRepository.self) { resolver in
            CompaniesRepositoryImpl(companiesRemote: resolver.resolve(CompaniesRemote.self)!)
        }

        container.register(ReviewsRepository.self) { resolver in
            ReviewsRepositoryImpl(reviewsRemote: resolver.resolve(ReviewsRemote.self)!)
        }

        container.register(BugsRepository.self) { resolver in
            BugsRepositoryImpl(bugsRemote: resolver.resolve(BugsRemote.self)!)
        }

        container.register(CodesRepository.self) { resolver in
            CodesRepositoryImpl(codesRemote: resolver.resolve(CodesRemote.self)!)
        }

        container.register(FilesRepository.self) { resolver in
            FilesRepositoryImpl(filesRemote: resolver.resolve(FilesRemote.self)!)
        }
    }
}
