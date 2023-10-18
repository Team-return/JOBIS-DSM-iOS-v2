import Foundation

public enum DevelopmentType: String, Codable {
    case all = "ALL"
    case server = "SERVER"
    case web = "WEB"
    case android = "ANDROID"
    case ios = "IOS"

    public func localizedString() -> String {
        switch self {
        case .all:
            return "전체"

        case .server:
            return "서버"

        case .web:
            return "웹"

        case .android:
            return "안드로이드"

        case .ios:
            return "iOS"
        }
    }
}
