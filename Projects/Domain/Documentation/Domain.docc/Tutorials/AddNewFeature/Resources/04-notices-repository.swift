import RxSwift

// Domain 레이어에 프로토콜만 정의합니다.
// 실제 구현체는 Data 레이어에 있습니다.
public protocol NoticesRepository {
    func fetchNoticeList() -> Single<[NoticeEntity]>
    func fetchNoticeDetail(id: Int) -> Single<NoticeDetailEntity>
}
