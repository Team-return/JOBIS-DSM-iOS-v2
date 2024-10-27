import Moya
import Domain
import AppNetwork

enum UsersAPI {
    case signin(SigninRequestQuery)
    case deleteDeviceToken
}

extension UsersAPI: JobisAPI {
    typealias ErrorType = UsersError

    var domain: JobisDomain {
        .users
    }

    var urlPath: String {
        switch self {
        case .signin:
            return "/login"
        case .deleteDeviceToken:
            return "/device-token"
        }
    }

    var method: Method {
        switch self {
        case .signin:
            return .post
        case .deleteDeviceToken:
            return .patch
        }
    }

    var task: Task {
        switch self {
        case let .signin(req):
            return .requestJSONEncodable(req)
        default:
            return .requestPlain
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        case .deleteDeviceToken:
            return .accessToken
        default:
            return .none
        }
    }

    var errorMap: [Int: ErrorType]? {
        switch self {
        case .signin:
            return [
                400: .badRequest,
                401: .notFoundPassword,
                404: .notFoundEmail,
                500: .internalServerError
            ]
        default:
            return nil
        }
    }
}
