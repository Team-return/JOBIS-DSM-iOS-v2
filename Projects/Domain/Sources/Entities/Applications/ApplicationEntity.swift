import Foundation

public struct ApplicationEntity: Equatable {
    public let applicationID: Int
    public let company: String
    public let attachments: [AttachmentsEntity]
    public let applicationStatus: ApplicationStatusType

    public init(
        applicationID: Int,
        company: String,
        attachments: [AttachmentsEntity],
        applicationStatus: ApplicationStatusType
    ) {
        self.applicationID = applicationID
        self.company = company
        self.attachments = attachments
        self.applicationStatus = applicationStatus
    }
}
