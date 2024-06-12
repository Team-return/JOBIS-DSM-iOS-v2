import RxFlow

public enum CompanyDetailStep: Step {
    case companyDetailIsRequired
    case popIsRequired
    case recruitmentDetailIsRequired(id: Int)
    case interviewReviewDetailIsRequired(
        id: Int,
        name: String
    )
}
