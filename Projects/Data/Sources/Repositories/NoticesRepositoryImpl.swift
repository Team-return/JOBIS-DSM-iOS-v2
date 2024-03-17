import RxSwift
import Domain

struct NoticesRepositoryImpl: NoticesRepository {
    private let remoteNoticesDataSource: any RemoteNoticesDataSource

    init(
        remoteNoticesDataSource: any RemoteNoticesDataSource
    ) {
        self.remoteNoticesDataSource = remoteNoticesDataSource
    }

    func fetchNoticeList() -> Single<[NoticeEntity]> {
        remoteNoticesDataSource.fetchNoticeList()
    }

    func fetchNotcieDetail(id: Int) -> Single<NoticeDetailEntity> {
        remoteNoticesDataSource.fetchNoticeDetail(id: id)
    }
}
