import RxFlow

public enum ReviewFilterStep: Step {
    case reviewFilterIsRequired
    case popToReview(
        jobCode: String?,
        year: String?,
        interviewType: String?,
        location: String?
    )
}
