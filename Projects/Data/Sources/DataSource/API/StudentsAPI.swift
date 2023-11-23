import Moya
import AppNetwork
import Domain

enum StudentsAPI {
    case signup(SignupRequestQuery)
    case renewalPassword(RenewalPasswordRequestQuery)
    case studentExists(gcn: String, name: String)
    case fetchStudentInfo
    case compareCurrentPasssword(password: String)
    case changePassword(ChangePasswordRequestQuery)
    case changeProfileImage(url: String)
}

extension StudentsAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .students
    }

    var urlPath: String {
        switch self {
        case .signup:
            return ""

        case .renewalPassword:
            return "/forgotten_password"

        case .studentExists:
            return "/exists"

        case .fetchStudentInfo:
            return "/my"

        case .compareCurrentPasssword, .changePassword:
            return "/password"

        case .changeProfileImage:
            return "/profile"
        }
    }

    var method: Method {
        switch self {
        case .signup:
            return .post

        case .renewalPassword, .changePassword, .changeProfileImage:
            return .patch

        case .studentExists, .fetchStudentInfo, .compareCurrentPasssword:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .signup(req):
            return .requestJSONEncodable(req)

        case let .renewalPassword(req):
            return .requestJSONEncodable(req)

        case let .studentExists(gcn, name):
            return .requestParameters(
                parameters: [
                    "gcn": gcn,
                    "name": name
                ],
                encoding: URLEncoding.queryString)

        case .fetchStudentInfo:
            return .requestPlain

        case let .compareCurrentPasssword(password):
            return .requestParameters(
                parameters: [
                    "password": password
                ], encoding: URLEncoding.queryString)

        case let .changePassword(req):
            return .requestJSONEncodable(req)

        case let .changeProfileImage(url):
            return .requestParameters(
                parameters: [
                    "profile_image_url": url
                ], encoding: JSONEncoding.default)
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchStudentInfo, .compareCurrentPasssword, .changePassword, .changeProfileImage:
            return .accessToken
        default:
            return .none
        }
    }

    var errorMap: [Int: ErrorType]? {
        return nil
    }
}
