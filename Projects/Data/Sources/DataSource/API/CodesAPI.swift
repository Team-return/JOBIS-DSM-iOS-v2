import Moya
import Domain
import AppNetwork

enum CodesAPI {
    case fetchCodeList(keyword: String?, type: CodeType, parentCode: String?)
}

extension CodesAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .codes
    }

    var urlPath: String {
        switch self {
        case .fetchCodeList:
            return ""
        }
    }

    var method: Method {
        switch self {
        case .fetchCodeList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .fetchCodeList(keyword, type, parentCode):
            return .requestParameters(
                parameters: [
                    "keyword": keyword ?? "",
                    "type": type.rawValue,
                    "parent_code": parentCode ?? ""
                ], encoding: URLEncoding.queryString)
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        default:
            return .none
        }
    }

    var errorMap: [Int: ErrorType]? {
        switch self {
        case .fetchCodeList:
            return [:]
        }
    }
}
