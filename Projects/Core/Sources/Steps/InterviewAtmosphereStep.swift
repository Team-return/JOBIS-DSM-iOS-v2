import RxFlow
import Domain

public enum InterviewAtmosphereStep: Step {
    case interviewAtmosphereIsRequired(
        companyID: Int,
        interviewType: InterviewFormat,
        location: LocationType,
        jobCode: Int,
        interviewerCount: Int
    )
    case navigateToWritableReview
    case popToWritableReview
    case popViewController
    case addQuestionIsRequired(qnas: [any Encodable])
}
