import Moya
import AppNetwork
import Domain

public enum NotificationsAPI {
    case fetchNotificationList
    case patchReadNotification(id: Int)
<<<<<<< Updated upstream
    case subscriptNotification(token: String, notificationType: NotificationType)
    case subscriptAllNotification(token: String)
=======
<<<<<<< Updated upstream
=======
    case subscriptNotification(token: String, notificationType: NotificationType)
    case subscriptAllNotification(token: String)
    case unsubscriptNotification(token: String, notificationType: NotificationType)
    case unsubscriptAllNotification(token: String)
>>>>>>> Stashed changes
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
<<<<<<< Updated upstream
=======
>>>>>>> Stashed changes

        case .subscriptNotification:
            return "/topic"

        case .subscriptAllNotification:
            return ""
<<<<<<< Updated upstream
=======

        case .unsubscriptNotification:
            return "/topic"

        case .unsubscriptAllNotification:
            return ""
>>>>>>> Stashed changes
>>>>>>> Stashed changes
        }
    }

    public var method: Method {
        switch self {
        case .fetchNotificationList:
            return .get

        case .patchReadNotification:
            return .patch
<<<<<<< Updated upstream

        case .subscriptNotification, .subscriptAllNotification:
            return .post
=======
<<<<<<< Updated upstream
=======

        case .subscriptNotification, .subscriptAllNotification:
            return .post

        case .unsubscriptNotification, .unsubscriptAllNotification:
            return .delete
>>>>>>> Stashed changes
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
<<<<<<< Updated upstream
=======
>>>>>>> Stashed changes

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

<<<<<<< Updated upstream
=======
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

>>>>>>> Stashed changes
>>>>>>> Stashed changes
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
