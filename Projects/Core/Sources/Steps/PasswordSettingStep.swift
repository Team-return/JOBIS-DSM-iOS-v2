import RxFlow

public enum PasswordSettingStep: Step {
    case tabsIsRequired
    case passwordSettingIsRequired(name: String, gcn: Int, email: String)
    case genderSettingIsRequired(name: String, gcn: Int, email: String, password: String)
}
