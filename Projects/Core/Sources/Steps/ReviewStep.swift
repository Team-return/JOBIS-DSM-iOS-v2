import RxFlow

public enum ReviewStep: Step {
    case reviewIsRequired
    case reviewDetailIsRequired(reviewId: Int)
    case searchReviewIsRequired
}
