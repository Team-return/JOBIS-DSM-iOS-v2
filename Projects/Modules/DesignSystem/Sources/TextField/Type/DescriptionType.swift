import UIKit

public enum DescriptionType: Equatable {
    case error(description: String)
    case info(description: String)
    case success(description: String)

    func toIcon() -> UIImage {
        switch self {
        case .error:
            return .textFieldIcon(.error)
        case .info:
            return .textFieldIcon(.info)
        case .success:
            return .textFieldIcon(.success)
        }
    }
}
