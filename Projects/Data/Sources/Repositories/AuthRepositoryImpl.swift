import RxSwift
import Domain

final class AuthRepositoryImpl: AuthRepository {
    private let authRemote: any AuthRemote

    init(authRemote: AuthRemote) {
        self.authRemote = authRemote
    }

    func sendAuthCode(req: SendAuthCodeRequestQuery) -> Completable {
        authRemote.sendAuthCode(req: req)
    }

    func reissueToken() -> Single<ReissueAuthorityEntity> {
        authRemote.reissueToken()
    }

    func verifyAuthCode(email: String, authCode: String) -> Completable {
        authRemote.verifyAuthCode(email: email, authCode: authCode)
    }
}
