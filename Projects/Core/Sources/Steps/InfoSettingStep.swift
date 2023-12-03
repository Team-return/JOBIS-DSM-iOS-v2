import RxFlow

public enum InfoSettingStep: Step {
    case tabsIsRequired
    case infoSettingIsRequired
    case verifyEmailIsRequired(name: String, gcn: Int)
}
