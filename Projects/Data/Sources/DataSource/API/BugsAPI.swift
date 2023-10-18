import Moya
import Domain
import AppNetwork

enum BugsAPI {
    case reportBug(ReportBugRequestQuery)
    case fetchBugList(DevelopmentType)
    case fetchBugDetail(id: Int)
}

extension BugsAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        return .bugs
    }

    var urlPath: String {
        switch self {
        case .reportBug, .fetchBugList:
            return "/"

        case let .fetchBugDetail(id):
            return "/\(id)/"
        }
    }

    var method: Method {
        switch self {
        case .reportBug:
            return .post

        case .fetchBugList, .fetchBugDetail:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .reportBug(req):
            return .requestJSONEncodable(req)

        case let .fetchBugList(developmentArea):
            return .requestParameters(
                parameters: [
                    "development_area": developmentArea.rawValue
                ],
                encoding: URLEncoding.queryString)

        case .fetchBugDetail:
            return .requestPlain
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        default:
            return .accessToken
        }
    }

    var errorMap: [Int: ErrorType]? {
        switch self {
        default:
            return [:]
        }
    }
}
