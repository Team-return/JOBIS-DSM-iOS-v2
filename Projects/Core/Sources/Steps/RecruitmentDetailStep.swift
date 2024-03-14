import RxFlow

public enum RecruitmentDetailStep: Step {
    case recruitmentDetailIsRequired
    case companyDetailIsRequired(id: Int)
}
