import RxFlow

public enum HomeStep: Step {
    case homeIsRequired
    case alarmIsRequired
    case companySearchIsRequired
    case rejectReasonIsRequired(
        recruitmentID: Int,
        applicationID: Int,
        companyName: String,
        companyImageURL: String
    )
    case reApplyIsRequired(
        recruitmentID: Int,
        applicationID: Int,
        companyName: String,
        companyImageURL: String
    )
}
