import RxFlow

public enum ApplyStep: Step {
    case applyIsRequired
    case reApplyIsRequired(applicationId: Int, name: String, imageURL: String)
    case homeIsRequired
    case errorToast(message: String)
}
