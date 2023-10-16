import RxSwift

public struct ReissueTokenUaseCase {
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    private let authRepository: AuthRepository

    public func execute() -> Single<ReissueAuthorityEntity> {
        return authRepository.reissueToken()
    }
}
