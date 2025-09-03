import RxFlow

public enum ReviewFilterStep: Step {
    case reviewFilterIsRequired
    case popToReview(jobCode: String?)
}
