import RxFlow

public enum MyPageStep: Step {
    case myPageIsRequired
    case tabsIsRequired
    case notificationSettingIsRequired
    case bookmarkIsRequired
    case writableReviewIsRequired(_ id: Int)
    case noticeIsRequired
    case confirmIsRequired
    case bugReportIsRequired
    case bugReportListIsRequired
    case interestFieldIsRequired
}
