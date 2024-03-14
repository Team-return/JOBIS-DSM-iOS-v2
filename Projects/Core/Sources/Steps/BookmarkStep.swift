import RxFlow

public enum BookmarkStep: Step {
    case bookmarkIsRequired
    case recruitmentDetailIsRequired(id: Int)
}
