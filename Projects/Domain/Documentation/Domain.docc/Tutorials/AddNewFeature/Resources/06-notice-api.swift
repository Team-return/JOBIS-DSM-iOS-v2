import Moya
import Domain
import AppNetwork

enum NoticeAPI {
    case fetchNoticeList
    case fetchNoticeDetail(id: Int)
}

extension NoticeAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        return .notices  // /notices 경로
    }

    var urlPath: String {
        switch self {
        case .fetchNoticeList:
            return ""           // GET /notices
        case let .fetchNoticeDetail(id):
            return "/\(id)"     // GET /notices/{id}
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchNoticeList, .fetchNoticeDetail:
            return .get
        }
    }

    var task: Task {
        return .requestPlain
    }

    var jwtTokenType: JwtTokenType {
        return .accessToken
    }

    var errorMap: [Int: ErrorType]? {
        return nil
    }
}
