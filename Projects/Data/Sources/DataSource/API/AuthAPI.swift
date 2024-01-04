import Moya
import Domain
import AppNetwork

enum AuthAPI {
    case verifyAuthCode(email: String, authCode: String)
    case sendAuthCode(SendAuthCodeRequestQuery)
    case reissueToken
}

extension AuthAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .auth
    }

    var urlPath: String {
        switch self {
        case .sendAuthCode, .verifyAuthCode:
            return "/code"

        case .reissueToken:
            return "/reissue"
        }
    }

    var method: Method {
        switch self {
        case .sendAuthCode:
            return .post

        case .verifyAuthCode:
            return .patch

        case .reissueToken:
            return .put
        }
    }

    var task: Task {
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
            return .requestParameters(parameters: [
                "platform-type": "IOS"
            ], encoding: URLEncoding.queryString)
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        case .reissueToken:
            return .refreshToken

        default:
            return .none
        }
    }

    var errorMap: [Int: ErrorType]? {
        return nil
    }
}
