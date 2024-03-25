import Foundation

public struct ApplicationEntity: Equatable {
    public let applicationID: Int
    public let recruitmentID: Int
    public let company: String
    public let companyLogoUrl: String
    public let attachments: [AttachmentsEntity]
    public let applicationStatus: ApplicationStatusType

    public init(
        applicationID: Int,
        recruitmentID: Int,
        company: String,
        companyLogoUrl: String,
        attachments: [AttachmentsEntity],
        applicationStatus: ApplicationStatusType
    ) {
        self.applicationID = applicationID
        self.recruitmentID = recruitmentID
        self.company = company
        self.companyLogoUrl = companyLogoUrl
        self.attachments = attachments
        self.applicationStatus = applicationStatus
    }
}
