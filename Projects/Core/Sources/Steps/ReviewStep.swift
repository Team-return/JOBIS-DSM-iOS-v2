import RxFlow

public enum ReviewStep: Step {
    case reviewIsRequired
    case reviewDetailIsRequired(reviewId: String)
    case searchReviewIsRequired
}
