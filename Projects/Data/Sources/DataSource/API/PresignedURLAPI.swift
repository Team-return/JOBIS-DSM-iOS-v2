import Moya
import Foundation
import AppNetwork
import Domain

public enum PresignedURLAPI {
    case uploadImageToS3(presignedURL: String, data: Data, contentType: String)
}

extension PresignedURLAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        .presignedURL
    }

    public var urlPath: String {
        ""
    }

    public var baseURL: URL {
        switch self {
        case let .uploadImageToS3(presignedURL, _, _):
            return URL(string: presignedURL) ?? URL(fileURLWithPath: "")
        }
    }

    public var path: String {
        return ""
    }

    public var method: Moya.Method {
        return .put
    }

    public var task: Moya.Task {
        switch self {
        case let .uploadImageToS3(_, data, _):
            return .requestData(data)
        }
    }

    public var headers: [String: String]? {
        switch self {
        case let .uploadImageToS3(_, _, contentType):
            return ["Content-Type": contentType]
        }
    }

    public var jwtTokenType: JwtTokenType {
        .none
    }

    public var errorMap: [Int: JobisError]? {
        [:]
    }
}
