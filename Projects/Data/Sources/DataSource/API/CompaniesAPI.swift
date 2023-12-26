import Moya
import Domain
import AppNetwork

enum CompaniesAPI {
    case fetchCompanyList(page: Int, name: String?)
    case fetchCompanyInfoDetail(id: Int)
    case fetchWritableReviewList
}

extension CompaniesAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .companies
    }

    var urlPath: String {
        switch self {
        case .fetchCompanyList:
            return "/student"

        case let .fetchCompanyInfoDetail(id):
            return "/\(id)"

        case .fetchWritableReviewList:
            return "/review"
        }
    }

    var method: Method {
        switch self {
        case .fetchCompanyList, .fetchCompanyInfoDetail, .fetchWritableReviewList:
            return .get
        }
    }

    var task: Task {
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

    var jwtTokenType: JwtTokenType {
        .accessToken
    }

    var errorMap: [Int: ErrorType]? {
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
