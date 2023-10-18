import Moya
import Domain
import AppNetwork

public enum BugsAPI {
    case reportBug(ReportBugRequestQuery)
    case fetchBugList(DevelopmentType)
    case fetchBugDetail(id: Int)
}

extension BugsAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        return .bugs
    }

    public var urlPath: String {
        switch self {
        case .reportBug, .fetchBugList:
            return "/"

        case let .fetchBugDetail(id):
            return "/\(id)/"
        }
    }

    public var method: Method {
        switch self {
        case .reportBug:
            return .post

        case .fetchBugList, .fetchBugDetail:
            return .get
        }
    }

    public var task: Task {
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

    public var jwtTokenType: JwtTokenType {
        switch self {
        default:
            return .accessToken
        }
    }

    public var errorMap: [Int: ErrorType]? {
        switch self {
        default:
            return [:]
        }
    }
}
