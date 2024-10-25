import Moya
import Domain
import AppNetwork

enum SystemAPI {
    case fetchServerStatus
}

extension SystemAPI: JobisAPI {
    typealias ErrorType = UsersError

    var domain: JobisDomain {
        .presignedURL
    }

    var urlPath: String {
        switch self {
        case .fetchServerStatus:
            return ""
        }
    }

    var method: Method {
        switch self {
        case .fetchServerStatus:
            return .get
        }
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        default:
            return .none
        }
    }

    var errorMap: [Int: ErrorType]? {
        return nil
    }
}
