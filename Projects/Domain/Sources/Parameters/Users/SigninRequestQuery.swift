import Foundation

public struct SigninRequestQuery: Encodable {
    public let accountID: String
    public let password: String
    public let platformType: String
    public let deviceToken: String?

    public init(
        accountID: String,
        password: String,
        deviceToken: String?
    ) {
        self.accountID = accountID
        self.password = password
        self.platformType = "IOS"
        self.deviceToken = deviceToken
    }

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case password
        case platformType = "platform_type"
        case deviceToken = "device_token"
    }
}
