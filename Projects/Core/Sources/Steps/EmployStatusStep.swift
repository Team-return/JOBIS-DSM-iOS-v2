import RxFlow

public enum EmployStatusStep: Step {
    case employStatusIsRequired
    case classEmploymentIsRequired(classNumber: Int)
}
