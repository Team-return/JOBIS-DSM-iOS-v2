import Foundation

public struct RecentCompanyEntity: Equatable {
    public let companyID: Int
    public let companyName: String
    public let companyLogoURL: String
    public let isRecruiting: Bool
    
    public init(
        companyID: Int,
        companyName: String,
        companyLogoURL: String,
        isRecruiting: Bool
    ) {
        self.companyID = companyID
        self.companyName = companyName
        self.companyLogoURL = companyLogoURL
        self.isRecruiting = isRecruiting
    }
}
