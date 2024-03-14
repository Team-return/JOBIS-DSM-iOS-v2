import RxFlow

public enum ConfirmEmailStep: Step {
    case confirmEmailIsRequired
    case renewalPasswordIsRequired(email: String)
}
