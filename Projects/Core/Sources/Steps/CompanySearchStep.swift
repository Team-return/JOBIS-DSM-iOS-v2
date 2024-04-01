import RxFlow

public enum CompanySearchStep: Step {
    case companySearchIsRequired
    case companyDetailIsRequired(id: Int)
}
