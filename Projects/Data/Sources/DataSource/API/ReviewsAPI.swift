import Moya
import Domain
import AppNetwork
import Foundation

enum ReviewsAPI {
    case postReview(PostReviewRequestQuery)
    case fetchReviewListPageCount(ReviewListPageCountRequestQuery)
    case fetchReviewDetail(reviewID: String)
    case fetchReviewList(ReviewListRequestQuery)
}

extension ReviewsAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        .reviews
    }

    var urlPath: String {
        switch self {
        case .postReview, .fetchReviewList:
            return ""
        case .fetchReviewListPageCount:
            return "/count"
        case let .fetchReviewDetail(reviewID):
            return "/\(reviewID)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchReviewListPageCount, .fetchReviewDetail, .fetchReviewList:
            return .get
        case .postReview:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .postReview(req):
            return .requestJSONEncodable(req)
        case let .fetchReviewListPageCount(req):
            return .requestParameters(parameters: req.toDictionary(), encoding: URLEncoding.queryString)
        case let .fetchReviewList(req):
            return .requestParameters(parameters: req.toDictionary(), encoding: URLEncoding.queryString)
        case .fetchReviewDetail:
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
        switch self {
        default:
            return [:]
        }
    }
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary.compactMapValues { $0 }
    }
}
