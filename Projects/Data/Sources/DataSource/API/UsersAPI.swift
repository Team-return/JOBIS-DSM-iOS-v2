import Moya
import Domain
import AppNetwork

public enum UsersAPI {
    case signin(SigninRequestQuery)
}

extension UsersAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        .users
    }

    public var urlPath: String {
        switch self {
        case .signin:
            return "/login"
        }
    }

    public var method: Method {
        switch self {
        case .signin:
            return .post
        }
    }

    public var task: Task {
        switch self {
        case let .signin(req):
            return .requestJSONEncodable(req)
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        default:
            return .none
        }
    }

    public var errorMap: [Int: ErrorType]? {
        switch self {
        case .signin:
            return [:]
        }
    }
}
