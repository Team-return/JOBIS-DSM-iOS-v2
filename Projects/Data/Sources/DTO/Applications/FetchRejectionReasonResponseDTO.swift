import Foundation

public struct FetchRejectionReasonResponseDTO: Decodable {
    public let rejectionReason: String

    public init(rejectionReason: String) {
        self.rejectionReason = rejectionReason
    }

    enum CodingKeys: String, CodingKey {
        case rejectionReason = "rejection_reason"
    }
}
