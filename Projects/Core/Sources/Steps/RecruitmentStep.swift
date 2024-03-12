import RxFlow

public enum RecruitmentStep: Step {
    case recruitmentIsRequired
    case recruitmentDetailIsRequired(recruitmentId: Int)
}
