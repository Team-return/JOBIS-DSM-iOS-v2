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
        return .notices
    }

    var urlPath: String {
        switch self {
        case .fetchNoticeList:
            return ""
        case let .fetchNoticeDetail(id):
            return "/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchNoticeList, .fetchNoticeDetail:
            return .get
        }
    }

    public var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        default:
            return .accessToken
        }
    }

    var errorMap: [Int: ErrorType]? {
        return nil
    }
}
