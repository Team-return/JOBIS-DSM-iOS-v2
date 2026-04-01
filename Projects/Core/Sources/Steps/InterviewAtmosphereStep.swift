import RxFlow

public enum InterviewAtmosphereStep: Step {
    case interviewAtmosphereIsRequired(
        companyID: Int,
        interviewType: String,
        location: String,
        jobCode: Int,
        interviewerCount: Int
    )
    case navigateToWritableReview
    case popToWritableReview
    case popViewController
    case addQuestionIsRequired(qnas: [any Encodable])
}
