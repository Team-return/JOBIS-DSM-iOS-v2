import RxSwift

public protocol NoticesRepository {
    func fetchNoticeList() -> Single<[NoticeEntity]>
    func fetchNotcieDetail(id: Int) -> Single<NoticeDetailEntity>
}
