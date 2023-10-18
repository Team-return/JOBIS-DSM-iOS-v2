import RxSwift
import Domain

protocol UsersRemote {
    func signin(req: SigninRequestQuery) -> Single<AuthorityType>
}

final class UsersRemoteImpl: BaseRemote<UsersAPI>, UsersRemote {
    func signin(req: SigninRequestQuery) -> Single<AuthorityType> {
        request(.signin(req))
            .map(AuthTokenResponseDTO.self)
            .map { $0.toDomain() }
    }
}
