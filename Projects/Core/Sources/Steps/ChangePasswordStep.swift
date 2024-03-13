import RxFlow

public enum ChangePasswordStep: Step {
    case tabsIsRequired
    case changePasswordIsRequired(currentPassword: String)
}
