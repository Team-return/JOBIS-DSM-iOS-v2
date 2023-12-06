import RxSwift
import Domain

struct AuthRepositoryImpl: AuthRepository {
    private let remoteAuthDataSource: any RemoteAuthDataSource

    init(remoteAuthDataSource: any RemoteAuthDataSource) {
        self.remoteAuthDataSource = remoteAuthDataSource
    }

    func sendAuthCode(req: SendAuthCodeRequestQuery) -> Completable {
        remoteAuthDataSource.sendAuthCode(req: req)
    }

    func reissueToken() -> Single<AuthorityType> {
        remoteAuthDataSource.reissueToken()
    }

    func verifyAuthCode(email: String, authCode: String) -> Completable {
        remoteAuthDataSource.verifyAuthCode(email: email, authCode: authCode)
    }
}
