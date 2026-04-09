import RxFlow

// NoticeDetailFlow의 init에 noticeID를 전달하므로
// Step에는 연관값이 필요 없습니다.
public enum NoticeDetailStep: Step {
    case noticeDetailIsRequired
    case noticeListIsRequired
}
