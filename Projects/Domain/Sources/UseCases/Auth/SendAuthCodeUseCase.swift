import RxSwift

public struct SendAuthCodeUseCase {
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    private let authRepository: AuthRepository

    public func execute(req: SendAuthCodeRequestQuery) -> Completable {
        return authRepository.sendAuthCode(req: req)
    }
}
