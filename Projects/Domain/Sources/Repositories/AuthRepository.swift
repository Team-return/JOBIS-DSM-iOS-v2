import RxSwift

public protocol AuthRepository {
    func sendAuthCode(req: SendAuthCodeRequestQuery) -> Completable
    func reissueToken() -> Single<AuthorityType>
    func verifyAuthCode(email: String, authCode: String) -> Completable
}
