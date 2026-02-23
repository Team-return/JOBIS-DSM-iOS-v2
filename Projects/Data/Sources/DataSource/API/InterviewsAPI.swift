import Moya
import AppNetwork
import Domain

enum InterviewsAPI {
    case fetchInterviewScheduleList(year: Int, month: Int, interviewType: String?, companyName: String?)
    case addInterviewSchedule(AddInterviewScheduleRequestQuery)
}

extension InterviewsAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .interviews
    }

    var urlPath: String {
        return ""
    }

    var method: Method {
        switch self {
        case .fetchInterviewScheduleList: return .get
        case .addInterviewSchedule: return .post
        }
    }

    var task: Task {
        switch self {
        case let .fetchInterviewScheduleList(year, month, interviewType, companyName):
            var params: [String: Any] = [
                "year": year,
                "month": month
            ]
            if let interviewType { params["interview_type"] = interviewType }
            if let companyName { params["company_name"] = companyName }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case let .addInterviewSchedule(req):
            return .requestJSONEncodable(req)
        }
    }

    var jwtTokenType: JwtTokenType {
        return .accessToken
    }

    var errorMap: [Int: ErrorType]? {
        return [:]
    }
}
