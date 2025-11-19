import RxFlow

public enum EmployStatusStep: Step {
    case employStatusIsRequired
    case classEmploymentIsRequired(classNumber: Int)
    case employmentFilterIsRequired
    case applyYearFilter(year: Int)
}
