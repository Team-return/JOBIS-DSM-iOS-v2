import Moya
import Domain
import AppNetwork
import Foundation
import RxSwift
import RxMoya
import Core
import Alamofire

class RemoteBaseDataSource<API: JobisAPI> {
    private let keychain: any Keychain

    private let provider: MoyaProvider<API>

    init(keychain: any Keychain) {
        self.keychain = keychain
#if DEBUG
        self.provider = MoyaProvider<API>(plugins: [JwtPlugin(keychain: keychain), MoyaLogginPlugin()])
#else
        self.provider = MoyaProvider<API>(plugins: [JwtPlugin()])
#endif
    }

    func request(_ api: API) -> Single<Response> {
        return .create { single in
            var disposables: [Disposable] = []
            if self.isApiNeedsAccessToken(api) {
                disposables.append(
                    self.requestWithAccessToken(api)
                        .subscribe(
                            onSuccess: { single(.success($0)) },
                            onFailure: { single(.failure($0)) }
                        )
                )
            } else {
                disposables.append(
                    self.defaultRequest(api)
                        .subscribe(
                            onSuccess: { single(.success($0)) },
                            onFailure: { single(.failure($0)) }
                        )
                )
            }
            return Disposables.create(disposables)
        }
    }
}

private extension RemoteBaseDataSource {
    func defaultRequest(_ api: API) -> Single<Response> {
        return provider.rx
            .request(api)
            .timeout(.seconds(120), scheduler: MainScheduler.asyncInstance)
            .catch { error in
                guard let code = (error as? MoyaError)?.response?.statusCode else {
                    return .error(error)
                }
                if code == 401 && API.self != AuthAPI.self {
                    return self.reissueToken()
                        .andThen(.error(TokenError.expired))
                }
                return .error(
                    api.errorMap?[code] ??
                    JobisError.error(
                        message: (try? (error as? MoyaError)?
                            .response?
                            .mapJSON() as? NSDictionary)?["message"] as? String ?? "",
                        errorBody: [:]
                    )
                )
            }
    }

    func requestWithAccessToken(_ api: API) -> Single<Response> {
        return .deferred {
            if self.checkTokenIsValid() {
                return self.defaultRequest(api)
            } else {
                return .error(TokenError.expired)
            }
        }
        .retry(when: { (errorObservable: Observable<TokenError>) in
            return errorObservable
                .flatMap { error -> Observable<Void> in
                    switch error {
                    case .expired:
                        return self.reissueToken()
                            .andThen(.just(()))
                    }
                }
        })
    }

    func isApiNeedsAccessToken(_ api: API) -> Bool {
        return api.jwtTokenType == .accessToken
    }

    func checkTokenIsValid() -> Bool {
        let expired = keychain.load(type: .accessExpiresAt).toJobisDate()
        print(Date(), expired)
        return Date() < expired
    }

    func reissueToken() -> Completable {
        return RemoteAuthDataSourceImpl(keychain: keychain).reissueToken()
            .asCompletable()
    }
}
