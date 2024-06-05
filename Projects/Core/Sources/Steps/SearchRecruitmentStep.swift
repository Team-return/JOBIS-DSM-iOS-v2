import RxFlow

public enum SearchRecruitmentStep: Step {
    case searchRecruitmentIsRequired
    case recruitmentDetailIsRequired(id: Int)
}
