import RxSwift
import Domain

protocol RemoteUsersDataSource {
    func signin(req: SigninRequestQuery) -> Single<AuthorityType>
}

final class RemoteUsersDataSourceImpl: RemoteBaseDataSource<UsersAPI>, RemoteUsersDataSource {
    func signin(req: SigninRequestQuery) -> Single<AuthorityType> {
        request(.signin(req))
            .map(AuthTokenResponseDTO.self)
            .map { $0.toDomain() }
    }
}
