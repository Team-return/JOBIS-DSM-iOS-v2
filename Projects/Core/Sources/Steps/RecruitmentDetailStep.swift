import RxFlow

public enum RecruitmentDetailStep: Step {
    case recruitmentDetailIsRequired
    case companyDetailIsRequired(id: Int)
    case applyIsRequired(id: Int, name: String, imageURL: String)
}
