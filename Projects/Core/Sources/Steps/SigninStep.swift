import RxFlow

public enum SigninStep: Step {
    case signinIsRequired
    case tabsIsRequired
    case confirmEmailIsRequired
}
