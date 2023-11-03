import RxSwift
import Domain
import AppNetwork

protocol RemoteAuthDataSource {
    func sendAuthCode(req: SendAuthCodeRequestQuery) -> Completable
    func reissueToken() -> Single<AuthorityType>
    func verifyAuthCode(email: String, authCode: String) -> Completable
}

final class RemoteAuthDataSourceImpl: RemoteBaseDataSource<AuthAPI>, RemoteAuthDataSource {
    func sendAuthCode(req: SendAuthCodeRequestQuery) -> Completable {
        return request(.sendAuthCode(req))
            .asCompletable()
    }

    func reissueToken() -> Single<AuthorityType> {
        return request(.reissueToken)
            .map(AuthTokenResponseDTO.self)
            .map { $0.toDomain() }
    }

    func verifyAuthCode(email: String, authCode: String) -> Completable {
        return request(.verifyAuthCode(email: email, authCode: authCode))
            .asCompletable()
    }
}
