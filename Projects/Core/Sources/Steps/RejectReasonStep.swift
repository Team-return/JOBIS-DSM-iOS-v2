import RxFlow

public enum RejectReasonStep: Step {
    case rejectReasonIsRequired(
        applicationID: Int,
        recruitmentID: Int,
        companyName: String,
        companyImageUrl: String
    )
    case reApplyIsRequired(
        recruitmentID: Int,
        applicationID: Int,
        companyName: String,
        companyImageUrl: String
    )
}
