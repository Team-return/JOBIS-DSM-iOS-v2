import Foundation
import Swinject
import Domain

public final class RepositoryAssembly: Assembly {
    public init() {}

    // swiftlint:disable function_body_length
    public func assemble(container: Container) {
        container.register(AuthRepository.self) { resolver in
            AuthRepositoryImpl(remoteAuthDataSource: resolver.resolve(RemoteAuthDataSource.self)!)
        }

        container.register(UsersRepository.self) { resolver in
            UsersRepositoryImpl(
                remoteUsersDataSource: resolver.resolve(RemoteUsersDataSource.self)!,
                localUsersDataSource: resolver.resolve(LocalUsersDataSource.self)!
            )
        }

        container.register(StudentsRepository.self) { reslover in
            StudentsRepositoryImpl(
                remoteStudentsDataSource: reslover.resolve(RemoteStudentsDataSource.self)!
            )
        }

        container.register(CompaniesRepository.self) { resolver in
            CompaniesRepositoryImpl(
                remoteCompaniesDataSource: resolver.resolve(RemoteCompaniesDataSource.self)!
            )
        }

        container.register(ReviewsRepository.self) { resolver in
            ReviewsRepositoryImpl(
                remoteReviewsDataSource: resolver.resolve(RemoteReviewsDataSource.self)!
            )
        }

        container.register(ApplicationsRepository.self) { resolver in
            ApplicationsRepositoryImpl(
                remoteApplicationsDataSource: resolver.resolve(RemoteApplicationsDataSource.self)!
            )
        }

        container.register(BugsRepository.self) { resolver in
            BugsRepositoryImpl(
                remoteBugsDataSource: resolver.resolve(RemoteBugsDataSource.self)!
            )
        }

        container.register(BookmarksRepository.self) { resolver in
            BookmarksRepositoryImpl(
                remoteBookmarksDataSource: resolver.resolve(RemoteBookmarksDataSource.self)!
            )
        }

        container.register(RecruitmentsRepository.self) { resolver in
            RecruitmentsRepositoryImpl(
                remoteRecruitmentsDataSource: resolver.resolve(RemoteRecruitmentsDataSource.self)!
            )
        }

        container.register(CodesRepository.self) { resolver in
            CodesRepositoryImpl(
                remoteCodesDataSource: resolver.resolve(RemoteCodesDataSource.self)!
            )
        }

        container.register(FilesRepository.self) { resolver in
            FilesRepositoryImpl(
                remoteFilesDataSource: resolver.resolve(RemoteFilesDataSource.self)!
            )
        }
        container.register(PresignedURLRepository.self) { resolver in
            PresignedURLRepositoryImpl(
                remotePresignedURLDataSource: resolver.resolve(RemotePresignedURLDataSource.self)!
            )
        }

        container.register(BannersRepository.self) { resolver in
            BannersRepositoryImpl(
                remoteBannersDataSource: resolver.resolve(RemoteBannersDataSource.self)!
            )
        }

        container.register(NoticesRepository.self) { resolver in
            NoticesRepositoryImpl(
                remoteNoticesDataSource: resolver.resolve(RemoteNoticesDataSource.self)!
            )
        }

        container.register(NotificationsRepository.self) { resolver in
            NotificationsRepositoryImpl(
                remoteNotificationsDataSource: resolver.resolve(RemoteNotificationsDataSource.self)!
            )
        }
    }
    // swiftlint:enable function_body_length
}
