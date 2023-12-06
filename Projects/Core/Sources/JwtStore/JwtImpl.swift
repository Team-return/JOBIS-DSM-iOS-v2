import KeychainSwift

public struct KeychainImpl: Keychain {
    private let keychain = KeychainSwift()

    public init() { }

    public func save(type: KeychainType, value: String) {
        keychain.set(value, forKey: type.rawValue)
    }

    public func load(type: KeychainType) -> String {
        return keychain.get(type.rawValue) ?? ""
    }

    public func delete(type: KeychainType) {
         keychain.delete(type.rawValue)
    }
}
