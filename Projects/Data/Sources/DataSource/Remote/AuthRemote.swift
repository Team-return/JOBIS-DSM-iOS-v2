import RxSwift
import Domain
import AppNetwork

public protocol AuthRemote {
    func sendAuthCode(req: SendAuthCodeRequestQuery) -> Completable
    func reissueToken() -> Single<ReissueAuthorityEntity>
    func verifyAuthCode(email: String, authCode: String) -> Completable
}

final class AuthRemoteImpl: BaseRemote<AuthAPI>, AuthRemote {
    func sendAuthCode(req: SendAuthCodeRequestQuery) -> Completable {
        return request(.sendAuthCode(req))
            .asCompletable()
    }

    func reissueToken() -> Single<ReissueAuthorityEntity> {
        return request(.reissueToken)
            .map(ReissueTokenResponseDTO.self)
            .map { $0.toDomain() }
    }

    func verifyAuthCode(email: String, authCode: String) -> Completable {
        return request(.verifyAuthCode(email: email, authCode: authCode))
            .asCompletable()
    }
}