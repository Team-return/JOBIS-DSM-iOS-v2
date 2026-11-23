import RxSwift
import Domain

struct NoticesRepositoryImpl: NoticesRepository {
    private let remoteNoticesDataSource: any RemoteNoticesDataSource

    init(
        remoteNoticesDataSource: any RemoteNoticesDataSource
    ) {
        self.remoteNoticesDataSource = remoteNoticesDataSource
    }

    func fetchNoticeList(page: Int) -> Single<[NoticeEntity]> {
        remoteNoticesDataSource.fetchNoticeList(page: page)
    }

    func fetchNotcieDetail(id: Int) -> Single<NoticeDetailEntity> {
        remoteNoticesDataSource.fetchNoticeDetail(id: id)
    }
}
