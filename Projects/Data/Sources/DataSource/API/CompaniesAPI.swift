import Moya
import Domain
import AppNetwork

public enum CompaniesAPI {
    case fetchCompanyList(page: Int, name: String?)
    case fetchCompanyInfoDetail(id: String)
    case fetchWritableReviewList
}

extension CompaniesAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        .companies
    }

    public var urlPath: String {
        switch self {
        case .fetchCompanyList:
            return "/student"

        case let .fetchCompanyInfoDetail(id):
            return "/\(id)"

        case .fetchWritableReviewList:
            return "/review"
        }
    }

    public var method: Method {
        switch self {
        case .fetchCompanyList, .fetchCompanyInfoDetail, .fetchWritableReviewList:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .fetchCompanyList(page, name):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "name": name ?? ""
                ], encoding: URLEncoding.queryString)

        default:
            return .requestPlain
        }
    }

    public var jwtTokenType: JwtTokenType {
        .accessToken
    }

    public var errorMap: [Int: ErrorType]? {
        switch self {
        case .fetchCompanyList:
            return [:]

        case .fetchCompanyInfoDetail:
            return [:]

        case .fetchWritableReviewList:
            return [:]
        }
    }
}
