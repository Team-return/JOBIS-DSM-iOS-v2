import Foundation

public enum NotificationType: String, Codable {
    case notice = "NEW_NOTICE"
    case recruitment = "RECRUITMENT_DONE"
    case application = "APPLICATION_STATUS_CHANGED"
    case interestRecruitment = "NEW_INTERESTED_RECRUITMENT"
    case winterIntern = "WINTER_INTERN_STATUS_CHANGED"
}
