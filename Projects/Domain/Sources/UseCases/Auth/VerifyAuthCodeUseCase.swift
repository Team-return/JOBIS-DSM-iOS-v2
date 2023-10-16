import RxSwift

public struct VerifyAuthCodeUseCase {
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    private let authRepository: AuthRepository

    public func execute(email: String, authCode: String) -> Completable {
        return authRepository.verifyAuthCode(email: email, authCode: authCode)
    }
}
