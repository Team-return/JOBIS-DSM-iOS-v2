import RxSwift

public struct ReissueTokenUseCase {
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    private let authRepository: AuthRepository

    public func execute() -> Single<AuthorityType> {
        return authRepository.reissueToken()
    }
}
