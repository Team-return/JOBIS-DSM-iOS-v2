import Moya
import Domain
import AppNetwork

enum RecruitmentsAPI {
    case fetchRecruitmentDetail(id: Int)
    case fetchRecruitmentList(page: Int, jobCode: String?, techCode: [String]?, name: String?)
}

extension RecruitmentsAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .recruitments
    }

    var urlPath: String {
        switch self {
        case let .fetchRecruitmentDetail(id):
            return "/\(id)"

        case .fetchRecruitmentList:
            return "/student"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchRecruitmentList, .fetchRecruitmentDetail:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .fetchRecruitmentList(page, jobCode, techCode, name):
            return .requestParameters(parameters: [
                "page": page,
                "job_code": jobCode ?? "",
                "tech_code": techCode?.joined(separator: ",") ?? "",
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
        case .fetchRecruitmentDetail:
            return [:]

        case .fetchRecruitmentList:
            return [:]
        }
    }
}
