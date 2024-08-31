import Moya
import AppNetwork
import Domain

public enum NotificationsAPI {
    case fetchNotificationList
    case patchReadNotification(id: Int)
    case subscriptNotification(token: String, notificationType: NotificationType)
    case subscriptAllNotification(token: String)
    case unsubscriptNotification(token: String, notificationType: NotificationType)
    case unsubscriptAllNotification(token: String)
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

        case .subscriptNotification:
            return "/topic"

        case .subscriptAllNotification:
            return ""

        case .unsubscriptNotification:
            return "/topic"

        case .unsubscriptAllNotification:
            return ""
        }
    }

    public var method: Method {
        switch self {
        case .fetchNotificationList:
            return .get

        case .patchReadNotification:
            return .patch

        case .subscriptNotification, .subscriptAllNotification:
            return .post

        case .unsubscriptNotification, .unsubscriptAllNotification:
            return .delete
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

        case let .subscriptNotification(token, notificationType):
            return .requestParameters(
                parameters: [
                    "token": token,
                    "topic": notificationType.rawValue
                ],
                encoding: URLEncoding.queryString
            )

        case let .subscriptAllNotification(token):
            return .requestParameters(
                parameters: [
                    "token": token
                ],
                encoding: URLEncoding.queryString
            )

        case let .unsubscriptNotification(token, notificationType):
            return .requestParameters(
                parameters: [
                    "token": token,
                    "topic": notificationType.rawValue
                ],
                encoding: URLEncoding.queryString
            )

        case let .unsubscriptAllNotification(token):
            return .requestParameters(
                parameters: [
                    "token": token
                ],
                encoding: URLEncoding.queryString
            )

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
