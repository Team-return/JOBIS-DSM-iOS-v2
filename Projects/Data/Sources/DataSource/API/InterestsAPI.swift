import Moya
import Domain
import AppNetwork

enum InterestsAPI {
    case fetchInterests
}

extension InterestsAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .interests
    }

    var urlPath: String {
        switch self {
        case .fetchInterests:
            return ""
        }
    }

    var method: Method {
        switch self {
        case .fetchInterests:
            return .get
        }
    }

    var task: Task {
        return .requestPlain
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchInterests:
            return .accessToken
        }
    }

    var errorMap: [Int: ErrorType]? {
        return [:]
    }
}
