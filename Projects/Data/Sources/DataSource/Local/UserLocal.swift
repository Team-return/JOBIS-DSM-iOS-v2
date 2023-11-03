import RxSwift
import Core
import Domain

protocol LocalUsersDataSource {
    func clearTokens()
}

public struct LocalUsersDataSourceImpl: LocalUsersDataSource {
    private let keychain: any Keychain

    public init(keychain: any Keychain) {
        self.keychain = keychain
    }

    public func clearTokens() {
        keychain.delete(type: .accessToken)
        keychain.delete(type: .accessExpiresAt)
        keychain.delete(type: .refreshToken)
        keychain.delete(type: .refreshExpiresAt)
    }
}
