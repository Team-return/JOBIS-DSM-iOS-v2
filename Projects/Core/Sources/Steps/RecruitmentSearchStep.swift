import RxFlow

public enum RecruitmentSearchStep: Step {
    case recruitmentSearchIsRequired
    case recruitmentDetailIsRequired(id: Int)
}
