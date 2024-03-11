import Foundation

public struct PresignedURLEntity: Equatable {
    public let filePath: String
    public let presignedUrl: String

    public init(filePath: String, presignedUrl: String) {
        self.filePath = filePath
        self.presignedUrl = presignedUrl
    }
}
