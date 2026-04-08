import Moya
import Domain
import AppNetwork

enum CompaniesAPI {
    case fetchCompanyList(page: Int, name: String?, sortType: String?)
    case fetchCompanyInfoDetail(id: Int)
    case fetchWritableReviewList
    case fetchRecentCompanyList
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

        case .fetchRecentCompanyList:
            return "/student/recent"
        }
    }

    var method: Method {
        switch self {
        case .fetchCompanyList, .fetchCompanyInfoDetail, .fetchWritableReviewList, .fetchRecentCompanyList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .fetchCompanyList(page, name, sortType):
            return .requestParameters(
                parameters: [
                    "page": page,
                    "name": name ?? "",
                    "sort_type": sortType ?? ""
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

        case .fetchRecentCompanyList:
            return [:]
        }
    }
}
