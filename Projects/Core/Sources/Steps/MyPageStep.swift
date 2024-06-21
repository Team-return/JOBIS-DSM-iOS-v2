import RxFlow

public enum MyPageStep: Step {
    case myPageIsRequired
    case tabsIsRequired
    case writableReviewIsRequired(_ id: Int)
    case noticeIsRequired
    case confirmIsRequired
}
