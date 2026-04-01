import RxFlow

public enum NoticeDetailStep: Step {
    case noticeDetailIsRequired(noticeID: Int)
    case noticeListIsRequired
}
