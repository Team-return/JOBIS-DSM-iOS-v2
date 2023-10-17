import Moya
import Domain
import AppNetwork

public enum AuthAPI {
    case verifyAuthCode(email: String, authCode: String)
    case sendAuthCode(SendAuthCodeRequestQuery)
    case reissueToken
}

extension AuthAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        .auth
    }

    public var urlPath: String {
        switch self {
        case .sendAuthCode, .verifyAuthCode:
            return "/code"

        case .reissueToken:
            return "/reissue"
        }
    }

    public var method: Method {
        switch self {
        case .sendAuthCode:
            return .post

        case .verifyAuthCode:
            return .patch

        case .reissueToken:
            return .put
        }
    }

    public var task: Task {
        switch self {
        case let .sendAuthCode(req):
            return .requestJSONEncodable(req)

        case let .verifyAuthCode(email, authCode):
            return .requestParameters(
                parameters: [
                    "email": email,
                    "auth_code": authCode
                ], encoding: URLEncoding.queryString
            )

        case .reissueToken:
            return .requestPlain
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .reissueToken:
            return .refreshToken

        default:
            return .none
        }
    }

    public var errorMap: [Int: ErrorType]? {
        return nil
    }
}
