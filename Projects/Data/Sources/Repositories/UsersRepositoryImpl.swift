import RxSwift
import Domain

final class UsersRepositoryImpl: UsersRepository {
    private let remoteUsersDataSource: any RemoteUsersDataSource
    private let localUsersDataSource: any LocalUsersDataSource

    init(
        remoteUsersDataSource: any RemoteUsersDataSource,
        localUsersDataSource: any LocalUsersDataSource
    ) {
        self.remoteUsersDataSource = remoteUsersDataSource
        self.localUsersDataSource = localUsersDataSource
    }

    func signin(req: SigninRequestQuery) -> Single<AuthorityType> {
        remoteUsersDataSource.signin(req: req)
    }

    func logout() {
        localUsersDataSource.clearTokens()
    }
}
