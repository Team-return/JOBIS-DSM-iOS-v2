import Foundation
import Swinject
import Core
import Domain

public final class DataSourceAssembly: Assembly {
    public init() {}

    private let keychain = { (resolver: Resolver) in
        resolver.resolve(Keychain.self)!
    }

    public func assemble(container: Container) {
        container.register(RemoteAuthDataSource.self) { resolver in
            RemoteAuthDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteUsersDataSource.self) { resolver in
            RemoteUsersDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(LocalUsersDataSource.self) { resolver in
            LocalUsersDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteCompaniesDataSource.self) { resolver in
            RemoteCompaniesDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteReviewsDataSource.self) { resolver in
            RemoteReviewsDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteApplicationsDataSource.self) { reslover in
            RemoteApplicationsDataSourceImpl(keychain: self.keychain(reslover))
        }

        container.register(RemoteBugsDataSource.self) { resolver in
            RemoteBugsDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteBookmarksDataSource.self) { resolver in
            RemoteBookmarksDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteRecruitmentsDataSource.self) { resolver in
            RemoteRecruitmentsDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteCodesDataSource.self) { resolver in
            RemoteCodesDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteFilesDataSource.self) { resolver in
            RemoteFilesDataSourceImpl(keychain: self.keychain(resolver))
        }
        container.register(RemotePresignedURLDataSource.self) { resolver in
            RemotePresignedURLDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteStudentsDataSource.self) { resolver in
            RemoteStudentsDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteBannersDataSource.self) { resolver in
            RemoteBannersDataSourceImpl(keychain: self.keychain(resolver))
        }

        container.register(RemoteNoticesDataSource.self) { resolver in
            RemoteNoticesDataSourceDataSourceImpl(keychain: self.keychain(resolver))
        }
    }
}
