import RxFlow

public enum RejectReasonStep: Step {
    case rejectReasonIsRequired
    case reApplyIsRequired(
        recruitmentID: Int,
        applicationID: Int,
        companyName: String,
        companyImageUrl: String
    )
}
