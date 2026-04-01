import RxFlow

public enum RecruitmentDetailStep: Step {
    case recruitmentDetailIsRequired(id: Int?, companyId: Int?, type: RecruitmentDetailPreviousViewType)
    case companyDetailIsRequired(id: Int)
    case applyIsRequired(id: Int, name: String, imageURL: String)
}
