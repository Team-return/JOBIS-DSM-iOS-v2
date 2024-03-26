import RxFlow

public enum ApplyStep: Step {
    case applyIsRequired(recruitmentId: Int, name: String, imageURL: String)
    case reApplyIsRequired(applicationId: Int, name: String, imageURL: String)
    case popToRecruitmentDetail
    case errorToast(message: String)
}
