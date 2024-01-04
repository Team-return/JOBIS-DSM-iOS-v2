import Foundation

public struct SigninRequestQuery: Encodable {
    public let accountID: String
    public let password: String
    public let platformType: String

    public init(accountID: String, password: String) {
        self.accountID = accountID
        self.password = password
        self.platformType = "IOS"
    }

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case password
        case platformType = "platform_type"
    }
}
