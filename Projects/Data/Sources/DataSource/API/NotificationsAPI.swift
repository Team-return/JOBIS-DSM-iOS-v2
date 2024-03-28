import Moya
import AppNetwork
import Domain

public enum NotificationsAPI {
    case fetchNotificationList
    case patchReadNotification(id: Int)
}

extension NotificationsAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        return .notifications
    }

    public var urlPath: String {
        switch self {
        case .fetchNotificationList:
            return ""

        case let .patchReadNotification(id):
            return "/\(id)"
        }
    }

    public var method: Method {
        switch self {
        case .fetchNotificationList:
            return .get

        case .patchReadNotification:
            return .patch
        }
    }

    public var task: Task {
        switch self {
        case .fetchNotificationList:
            return .requestParameters(
                parameters:
//                  // TODO: 추후 읽음와 안읽음 분기처리 필요
                    ["is_new": ""],
                encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        default:
            return .accessToken
        }
    }

    public var errorMap: [Int: ErrorType]? {
        return [:]
    }
}
