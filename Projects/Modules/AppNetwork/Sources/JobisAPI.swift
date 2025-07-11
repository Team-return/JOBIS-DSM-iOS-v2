import Foundation
import Moya

public protocol JobisAPI: TargetType, JwtAuthorizable {
    associatedtype ErrorType: Error
    var domain: JobisDomain { get }
    var urlPath: String { get }
    var errorMap: [Int: ErrorType]? { get }
}

public extension JobisAPI {
    var baseURL: URL {
        URL(
            string: Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String ?? ""
        ) ?? URL(string: "https://www.google.com")!
    }

    var path: String {
        domain.asURLString + urlPath
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

public enum JobisDomain: String {
    case auth
    case users
    case recruitments
    case companies
    case students
    case codes
    case applications
    case bookmarks
    case reviews
    case files
    case bugs
    case presignedURL = ""
    case banners
    case notices
    case notifications
    case winterIntern = "winter-intern"
    case interests
}

extension JobisDomain {
    var asURLString: String {
        "/\(self.rawValue)"
    }
}

private class BundleFinder {}

extension Foundation.Bundle {
    static let module = Bundle(for: BundleFinder.self)
}
