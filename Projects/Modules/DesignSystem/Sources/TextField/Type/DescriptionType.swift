import Foundation

public enum DescriptionType {
    case error(description: String)
    case info(description: String)
    case success(description: String)
    case none
}
