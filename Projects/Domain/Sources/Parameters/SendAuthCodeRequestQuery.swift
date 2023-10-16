import Foundation

public struct SendAuthCodeRequestQuery: Encodable {
    public let email: String
    public let authCodeType: AuthCodeType

    public init(email: String, authCodeType: AuthCodeType) {
        self.email = email
        self.authCodeType = authCodeType
    }

    enum CodingKeys: String, CodingKey {
        case email
        case authCodeType = "auth_code_type"
    }
}
