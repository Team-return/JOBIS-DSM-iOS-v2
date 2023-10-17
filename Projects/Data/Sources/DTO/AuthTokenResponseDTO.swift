import Foundation
import Domain
import AppNetwork

public struct AuthTokenResponseDTO: Decodable {
    public let authority: AuthorityType

    public init(authority: AuthorityType) {
        self.authority = authority
    }
}

public extension AuthTokenResponseDTO {
    func toDomain() -> AuthorityType {
        return authority
    }
}
