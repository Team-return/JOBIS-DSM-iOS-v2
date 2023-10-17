import Foundation
import Domain
import AppNetwork

public struct ReissueTokenResponseDTO: Decodable {
    public let authority: AuthorityType

    public init(authority: AuthorityType) {
        self.authority = authority
    }
}

public extension ReissueTokenResponseDTO {
    func toDomain() -> ReissueAuthorityEntity {
        ReissueAuthorityEntity(authority: authority)
    }
}
