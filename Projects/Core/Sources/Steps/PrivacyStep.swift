import RxFlow

public enum PrivacyStep: Step {
    case tabsIsRequired
    case privacyIsRequired(name: String, gcn: Int, email: String, password: String)
}
