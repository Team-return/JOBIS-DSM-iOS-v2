import Foundation
import Domain
import AppNetwork

struct AuthTokenResponseDTO: Decodable {
    let authority: AuthorityType
}

extension AuthTokenResponseDTO {
    func toDomain() -> AuthorityType {
        return authority
    }
}
