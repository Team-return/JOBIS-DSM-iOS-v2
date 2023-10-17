import RxSwift
import Domain

public protocol UsersRemote {
    func signin(req: SigninRequestQuery) -> Single<AuthorityEntity>
}

final class UsersRemoteImpl: BaseRemote<UsersAPI>, UsersRemote {
    func signin(req: SigninRequestQuery) -> Single<AuthorityEntity> {
        request(.signin(req))
            .map(AuthTokenResponseDTO.self)
            .map { $0.toDomain() }
    }
}
