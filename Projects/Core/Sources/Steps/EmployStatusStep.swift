import RxFlow

public enum EmployStatusStep: Step {
    case employStatusIsRequired
    case classEmploymentIsRequired(classNumber: Int, year: Int)
    case employmentFilterIsRequired(currentYear: Int)
    case applyYearFilter(year: Int)
}
