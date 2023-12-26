import Moya
import Domain
import AppNetwork

enum ApplicationsAPI {
    case applyCompany(id: Int, ApplyCompanyRequestQuery)
    case reApplyCompany(id: Int, ApplyCompanyRequestQuery)
    case cancelApply(id: Int)
    case fetchApplication
    case fetchTotalPassStudent
    case fetchRejectionReason(id: Int)
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

        case let .fetchRejectionReason(id):
            return "/rejection/\(id)"
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

        case .fetchApplication, .fetchTotalPassStudent, .fetchRejectionReason:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .applyCompany(_, req):
            return .requestJSONEncodable(req)

        case let .reApplyCompany(_, req):
            return .requestJSONEncodable(req)

        case .cancelApply, .fetchApplication, .fetchTotalPassStudent, .fetchRejectionReason:
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

        case .fetchRejectionReason:
            return [:]
        }
    }
}
