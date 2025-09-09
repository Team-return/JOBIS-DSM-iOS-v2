import RxFlow

public enum ReviewFilterStep: Step {
    case reviewFilterIsRequired
    case popToReview(
        code: String?,
        year: String?,
        type: String?,
        location: String?
    )
}
