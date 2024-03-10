import RxFlow

public enum GenderSettingStep: Step {
    case tabsIsRequired
    case genderSettingIsRequired(name: String, gcn: Int, email: String, password: String)
    case profileSettingIsRequired(name: String, gcn: Int, email: String, password: String, isMan: Bool)
}
