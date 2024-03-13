import RxFlow

public enum ConfirmPasswordStep: Step {
    case confirmPasswordIsRequired
    case changePasswordIsRequired(currentPassword: String)
}
