import Moya
import Domain
import AppNetwork

enum ApplicationsAPI {
    case applyCompany(id: String, ApplyCompanyRequestQuery)
    case reApplyCompany(id: String, ApplyCompanyRequestQuery)
    case cancelApply(id: String)
    case fetchApplication
    case fetchTotalPassStudent
}

extension ApplicationsAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .applications
    }

    var urlPath: String {
        switch self {
        case let .applyCompany(id, _):
            return "/\(id)"

        case let .reApplyCompany(id, _):
            return "/\(id)"

        case let .cancelApply(id):
            return "/\(id)"

        case .fetchApplication:
            return "/students"

        case .fetchTotalPassStudent:
            return "/employment/count"
        }
    }

    var method: Method {
        switch self {
        case .applyCompany:
            return .post

        case .reApplyCompany:
            return .put

        case .cancelApply:
            return .delete

        case .fetchApplication, .fetchTotalPassStudent:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .applyCompany(_, req):
            return .requestJSONEncodable(req)

        case let .reApplyCompany(_, req):
            return .requestJSONEncodable(req)

            return .requestPlain
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchApplication, .applyCompany, .reApplyCompany, .fetchRejectionReason:
            return .accessToken
        default:
            return .none
        }
    }

    public var errorMap: [Int: ErrorType]? {
        switch self {
        case .applyCompany:
            return [:]

        case .reApplyCompany:
            return [:]

        case .cancelApply:
            return [:]

        case .fetchApplication:
            return [:]

        case .fetchTotalPassStudent:
            return [:]
        }
    }
}
