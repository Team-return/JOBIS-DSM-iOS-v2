import RxFlow

public enum VerifyEmailStep: Step {
    case tabsIsRequired
    case verifyEmailIsRequired(name: String, gcn: Int)
    case passwordSettingIsRequired(name: String, gcn: Int, email: String)
}
