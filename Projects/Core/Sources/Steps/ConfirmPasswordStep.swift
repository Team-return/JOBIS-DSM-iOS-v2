import RxFlow

public enum ConfirmPasswordStep: Step {
    case tabsIsRequired
    case confirmPasswordIsRequired
    case changePasswordIsRequired(currentPassword: String)
}
