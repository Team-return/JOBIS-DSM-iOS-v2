import Moya
import Domain
import AppNetwork

enum InterestsAPI {
    case fetchInterests
    case updateInterests(interestsIDs: [Int])
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
        case .updateInterests:
            return ""
        }
    }

    var method: Method {
        switch self {
        case .fetchInterests:
            return .get
        case .updateInterests:
            return .patch
        }
    }

    var task: Task {
        switch self {
        case .fetchInterests:
            return .requestPlain
        case .updateInterests(let interestsIDs):
            return .requestParameters(
                parameters: [
                    "code_ids": interestsIDs
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchInterests, .updateInterests:
            return .accessToken
        }
    }

    var errorMap: [Int: ErrorType]? {
        return [:]
    }
}
