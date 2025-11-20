import Moya
import Domain
import AppNetwork

enum ApplicationsAPI {
    case applyCompany(id: Int, ApplyCompanyRequestQuery)
    case reApplyCompany(id: Int, ApplyCompanyRequestQuery)
    case cancelApply(id: Int)
    case fetchApplication
    case fetchTotalPassStudent(year: Int)
    case fetchRejectionReason(id: Int)
    case fetchEmploymentStatus(year: Int)
}

extension ApplicationsAPI: JobisAPI {
    typealias ErrorType = ApplicationsError

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

        case let .fetchTotalPassStudent(year):
            return "/employment/count/\(year)"

        case let .fetchRejectionReason(id):
            return "/rejection/\(id)"

        case let .fetchEmploymentStatus(year):
            return "/employment/\(year)"
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

        case .fetchApplication, .fetchTotalPassStudent, .fetchRejectionReason, .fetchEmploymentStatus:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .applyCompany(_, req):
            return .requestJSONEncodable(req)

        case let .reApplyCompany(_, req):
            return .requestJSONEncodable(req)

        case .cancelApply, .fetchApplication, .fetchTotalPassStudent, .fetchRejectionReason, .fetchEmploymentStatus:
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
            return [
                404: .badRequest,
                409: .conflict,
                500: .internalServerError
            ]

        case .reApplyCompany:
            return [
                404: .badRequest,
                409: .conflict,
                500: .internalServerError
            ]

        case .cancelApply:
            return [:]

        case .fetchApplication:
            return [:]

        case .fetchTotalPassStudent:
            return [:]

        case .fetchRejectionReason:
            return [:]

        case .fetchEmploymentStatus:
            return [:]
        }
    }
}
