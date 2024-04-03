import RxFlow

public enum SearchCompanyStep: Step {
    case searchCompanyIsRequired
    case companyDetailIsRequired(id: Int)
}
