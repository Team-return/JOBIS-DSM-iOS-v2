import Foundation

public enum JobisError: Error {
    case error(message: String = "에러가 발생했습니다.", errorBody: [String: Any] = [:])
    case noInternet
}

extension JobisError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .error(message, _):
            return message

        case .noInternet:
            return "인터넷 연결이 원활하지 않습니다."
        }
    }
}
