import RxSwift

public protocol NoticesRepository {
    func fetchNoticeList(page: Int) -> Single<[NoticeEntity]>
    func fetchNotcieDetail(id: Int) -> Single<NoticeDetailEntity>
}
