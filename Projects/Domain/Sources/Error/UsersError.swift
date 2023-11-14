import Foundation

public enum UsersError: Error {
    case notFoundPassword
    case notFoundEmail
    case internalServerError
}

extension UsersError: LocalizedError {
    public var errorDescription: String? {
        switch self {

        case .notFoundPassword:
            return "비밀번호를 확인해주세요."

        case .notFoundEmail:
            return "계정을 찾을 수 없습니다. 다시 한 번 확인해주세요."

        case .internalServerError:
            return "인터넷 환경을 확인해주세요."
        }
    }
}
