import RxFlow

public enum HomeStep: Step {
    case homeIsRequired
    case alarmIsRequired
    case companyIsRequired
    case winterInternIsRequired
    case easterEggIsRequired
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
    case recruitmentDetailIsRequired(id: Int)
    case none
}
