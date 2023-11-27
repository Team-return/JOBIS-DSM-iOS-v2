import RxFlow

public enum VerifyEmailStep: Step {
    case tabsIsRequired
    case verifyEmailIsRequired
    case passwordSettingIsRequired
}
