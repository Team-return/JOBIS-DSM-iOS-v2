import RxFlow

public enum ProfileSettingStep: Step {
    case tabsIsRequired
    case profileSettingIsRequired(name: String, gcn: Int, email: String, password: String, isMan: Bool)
    case privacyIsRequired(
        name: String,
        gcn: Int,
        email: String,
        password: String,
        isMan: Bool,
        profileImageURL: String?
    )
}
