import Foundation

public struct SignupRequestQuery: Encodable {
    public let email, password: String
    public let grade: Int
    public let name: String
    public let gender: GenderType
    public let classRoom, number: Int
    public let deviceToken: String?
    public let profileImageURL: String?
    public let platformType: String

    public init(
        email: String,
        password: String,
        grade: Int,
        name: String,
        gender: GenderType,
        classRoom: Int,
        number: Int,
        deviceToken: String?,
        profileImageURL: String?
    ) {
        self.email = email
        self.password = password
        self.grade = grade
        self.name = name
        self.gender = gender
        self.classRoom = classRoom
        self.number = number
        self.deviceToken = deviceToken
        self.profileImageURL = profileImageURL
        self.platformType = "IOS"
    }

    enum CodingKeys: String, CodingKey {
        case email
        case password, grade, name, gender
        case classRoom = "class_room"
        case number
        case deviceToken = "device_token"
        case profileImageURL = "profile_image_url"
        case platformType = "platform_type"
    }
}
