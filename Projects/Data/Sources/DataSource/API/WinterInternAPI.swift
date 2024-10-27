import Moya
import Domain
import AppNetwork

enum WinterInternAPI {
    case fetchWinterInternSeason
}

extension WinterInternAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .winterIntern
    }

    var urlPath: String {
        switch self {
        case .fetchWinterInternSeason:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchWinterInternSeason:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    var jwtTokenType: JwtTokenType {
        .accessToken
    }

    var errorMap: [Int: ErrorType]? {
        switch self {
        case .fetchWinterInternSeason:
            return [:]
        }
    }
}
