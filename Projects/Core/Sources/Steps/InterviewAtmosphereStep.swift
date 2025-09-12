import RxFlow

public enum InterviewAtmosphereStep: Step {
    case interviewAtmosphereIsRequired
    case navigateToWritableReview
    case popToWritableReview
    case popViewController
}
