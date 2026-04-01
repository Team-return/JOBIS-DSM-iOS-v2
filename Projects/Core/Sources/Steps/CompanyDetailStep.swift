import RxFlow

public enum CompanyDetailStep: Step {
    case companyDetailIsRequired(companyId: Int, type: CompanyDetailPreviousViewType)
    case popIsRequired
    case recruitmentDetailIsRequired(id: Int)
    case interviewReviewDetailIsRequired(
        id: Int,
        name: String
    )
}
