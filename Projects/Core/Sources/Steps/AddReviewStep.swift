import RxFlow

public enum AddReviewStep: Step {
    case addReviewIsRequired
    case interviewAtmosphereIsRequired
    case dismissToWritableReview
}
