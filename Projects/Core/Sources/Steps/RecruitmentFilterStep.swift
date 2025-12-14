import RxFlow

public enum RecruitmentFilterStep: Step {
    case recruitmentFilterIsRequired
    case popToRecruitment(jobCode: String?, techCode: [String]?, years: [String]?)
}
