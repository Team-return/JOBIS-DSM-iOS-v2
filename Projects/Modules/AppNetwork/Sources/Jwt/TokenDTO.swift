import Foundation

struct TokenDTO: Equatable, Decodable {
    let accessToken: String
    let refreshToken: String
    let accessExpiresAt: String
    let refreshExpiresAt: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case accessExpiresAt = "access_expires_at"
        case refreshExpiresAt = "refresh_expires_at"
    }
}
