import RxFlow

public enum CompanyStep: Step {
    case companyIsRequired
    case companyDetailIsRequired(id: Int)
    case searchCompanyIsRequired
}
